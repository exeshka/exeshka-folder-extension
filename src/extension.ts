import * as vscode from 'vscode';
import * as fs from 'fs';
import * as path from 'path';

export function activate(context: vscode.ExtensionContext) {
	let disposable = vscode.commands.registerCommand('extension.exeshkaCreateFolderSctruct', async () => {
		const workspaceFolders = vscode.workspace.workspaceFolders;

		if (!workspaceFolders) {
			vscode.window.showErrorMessage('Please open a folder or workspace first.');
			return;
		}

		// Путь к папке lib в проекте расширения
		const sourceFolder = path.join(context.extensionPath, 'src', 'dartCode', 'flutter_code_test', 'lib');
		console.log(`Source Folder: ${sourceFolder}`); // Отладочный вывод

		// Проверка, существует ли исходная папка
		if (!fs.existsSync(sourceFolder)) {
			vscode.window.showErrorMessage(`Source folder does not exist: ${sourceFolder}`);
			return;
		}

		// Выбор целевой папки с помощью диалога
		const targetUri = await vscode.window.showOpenDialog({
			canSelectFolders: true,
			openLabel: 'Select Destination Folder'
		});

		if (targetUri && targetUri.length > 0) {
			const targetFolder = targetUri[0].fsPath;

			// Копируем содержимое папки lib в выбранную целевую папку
			copyFolderRecursiveSync(sourceFolder, targetFolder);
			vscode.window.showInformationMessage('Files copied successfully!');
		}
	});

	context.subscriptions.push(disposable);
}












function copyFolderRecursiveSync(source: string, target: string) {
	// Проверка существования целевой папки и создание её, если нет
	if (!fs.existsSync(target)) {
		fs.mkdirSync(target, { recursive: true });
	}

	// Читаем файлы и папки в исходной папке
	const files = fs.readdirSync(source);

	for (const file of files) {
		const currentSource = path.join(source, file);
		const currentTarget = path.join(target, file);

		// Если это папка, рекурсивно копируем её
		if (fs.lstatSync(currentSource).isDirectory()) {
			copyFolderRecursiveSync(currentSource, currentTarget);
		} else {
			// Если это файл, копируем его
			fs.copyFileSync(currentSource, currentTarget);
		}
	}
}
