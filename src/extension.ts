import * as vscode from 'vscode';
import * as fs from 'fs';
import * as path from 'path';

const SOURCE_FOLDER_KEY = 'savedSourceFolder'; // Ключ для хранения пути

export function activate(context: vscode.ExtensionContext) {
	// Загружаем сохранённый путь из globalState
	let savedSourceFolder = context.globalState.get<string>(SOURCE_FOLDER_KEY);

	// Первая команда: Выбор и сохранение исходной папки
	let saveSourceFolder = vscode.commands.registerCommand('extension.saveSourceFolder', async () => {
		const sourceUri = await vscode.window.showOpenDialog({
			canSelectFolders: true,
			openLabel: 'Select Source Folder'
		});

		if (sourceUri && sourceUri.length > 0) {
			savedSourceFolder = sourceUri[0].fsPath;

			// Сохраняем путь в глобальном хранилище
			await context.globalState.update(SOURCE_FOLDER_KEY, savedSourceFolder);

			vscode.window.showInformationMessage(`Source folder saved: ${savedSourceFolder}`);
		} else {
			vscode.window.showErrorMessage('No folder selected.');
		}
	});

	// Вторая команда: Копирование файлов из сохраненной папки в целевую папку
	let copyToTargetFolder = vscode.commands.registerCommand('extension.copyToTargetFolder', async () => {
		// Проверяем, была ли сохранена исходная папка
		if (!savedSourceFolder) {
			vscode.window.showErrorMessage('Source folder is not saved. Run the "Save Source Folder" command first.');
			return;
		}

		// Выбор целевой папки
		const targetUri = await vscode.window.showOpenDialog({
			canSelectFolders: true,
			openLabel: 'Select Target Folder'
		});

		if (targetUri && targetUri.length > 0) {
			const targetFolder = targetUri[0].fsPath;

			// Копируем содержимое сохранённой папки в выбранную целевую папку
			copyFolderRecursiveSync(savedSourceFolder, targetFolder);
			vscode.window.showInformationMessage('Files copied successfully!');
		} else {
			vscode.window.showErrorMessage('No target folder selected.');
		}
	});

	context.subscriptions.push(saveSourceFolder, copyToTargetFolder);
}

// Функция для рекурсивного копирования файлов
function copyFolderRecursiveSync(source: string, target: string) {
	if (!fs.existsSync(target)) {
		fs.mkdirSync(target, { recursive: true });
	}

	const files = fs.readdirSync(source);

	for (const file of files) {
		const currentSource = path.join(source, file);
		const currentTarget = path.join(target, file);

		if (fs.lstatSync(currentSource).isDirectory()) {
			copyFolderRecursiveSync(currentSource, currentTarget);
		} else {
			fs.copyFileSync(currentSource, currentTarget);
		}
	}
}
