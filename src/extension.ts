import * as vscode from 'vscode';
import * as fs from 'fs';
import * as path from 'path';

const SAVED_PATHS_KEY = 'exeshka_folder_extension_savedPaths'; // Ключ для хранения путей

export function activate(context: vscode.ExtensionContext) {
	// Загружаем сохранённые пути из globalState
	let savedPaths = context.globalState.get<{ [key: string]: string }>(SAVED_PATHS_KEY, {});

	// Первая команда: Выбор и сохранение исходной папки с названием
	let saveSourceFolder = vscode.commands.registerCommand('extension.saveSourceFolder', async () => {
		const sourceUri = await vscode.window.showOpenDialog({
			canSelectFolders: true,
			openLabel: 'Select Source Folder'
		});

		if (sourceUri && sourceUri.length > 0) {
			const sourceFolder = sourceUri[0].fsPath;

			// Запросить у пользователя имя для этого пути
			const folderName = await vscode.window.showInputBox({
				prompt: 'Enter a name for this source folder'
			});

			if (folderName) {
				savedPaths[folderName] = sourceFolder;
				await context.globalState.update(SAVED_PATHS_KEY, savedPaths);

				vscode.window.showInformationMessage(`Source folder '${folderName}' saved: ${sourceFolder}`);
			} else {
				vscode.window.showErrorMessage('No name provided.');
			}
		} else {
			vscode.window.showErrorMessage('No folder selected.');
		}
	});

	// Вторая команда: Копирование файлов из сохраненной папки в целевую папку
	let copyToTargetFolder = vscode.commands.registerCommand('extension.copyToTargetFolder', async () => {
		const pathNames = Object.keys(savedPaths);

		if (pathNames.length === 0) {
			vscode.window.showErrorMessage('No saved source folders available.');
			return;
		}

		// Подготавливаем список с именами и путями для отображения
		const items: vscode.QuickPickItem[] = pathNames.map(name => ({
			label: name,
			description: savedPaths[name] // путь будет в виде подзаголовка
		}));

		// Показать пользователю список сохранённых путей для выбора
		const selectedSourceItem = await vscode.window.showQuickPick(items, {
			placeHolder: 'Select the source folder'
		});

		if (selectedSourceItem) {
			const sourceFolder = savedPaths[selectedSourceItem.label];

			// Выбор целевой папки
			const targetUri = await vscode.window.showOpenDialog({
				canSelectFolders: true,
				openLabel: 'Select Target Folder'
			});

			if (targetUri && targetUri.length > 0) {
				const targetFolder = targetUri[0].fsPath;

				// Копируем содержимое сохранённой папки в выбранную целевую папку
				copyFolderRecursiveSync(sourceFolder, targetFolder);
				vscode.window.showInformationMessage(`Files copied from '${selectedSourceItem.label}' to '${targetFolder}' successfully!`);
			} else {
				vscode.window.showErrorMessage('No target folder selected.');
			}
		} else {
			vscode.window.showErrorMessage('No source folder selected.');
		}
	});

	// Третья команда: Удаление сохранённого пути
	let deleteSavedFolder = vscode.commands.registerCommand('extension.deleteSavedFolder', async () => {
		const pathNames = Object.keys(savedPaths);

		if (pathNames.length === 0) {
			vscode.window.showErrorMessage('No saved source folders available.');
			return;
		}

		// Подготавливаем список с именами и путями для удаления
		const items: vscode.QuickPickItem[] = pathNames.map(name => ({
			label: name,
			description: savedPaths[name] // путь будет в виде подзаголовка
		}));

		// Показать пользователю список сохранённых путей для удаления
		const selectedSourceItem = await vscode.window.showQuickPick(items, {
			placeHolder: 'Select the source folder to delete'
		});

		if (selectedSourceItem) {
			delete savedPaths[selectedSourceItem.label];
			await context.globalState.update(SAVED_PATHS_KEY, savedPaths);
			vscode.window.showInformationMessage(`Source folder '${selectedSourceItem.label}' deleted successfully.`);
		} else {
			vscode.window.showErrorMessage('No folder selected for deletion.');
		}
	});

	context.subscriptions.push(saveSourceFolder, copyToTargetFolder, deleteSavedFolder);
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