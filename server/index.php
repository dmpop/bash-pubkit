<?php
// Theme (light, dark, sepia)
$theme = "dark";
// Footer
$footer = "This is <a href='https://github.com/dmpop/bash-pubkit'>Bash Pubkit</a>";
?>

<!DOCTYPE html>
<html lang="en" data-theme="<?php echo $theme ?>">
<!-- Author: Dmitri Popov, dmpop@linux.com
	 License: GPLv3 https://www.gnu.org/licenses/gpl-3.0.txt -->

<head>
	<meta charset="utf-8">
	<title>EPUB Compiler</title>
	<link rel="shortcut icon" href="favicon.png" />
	<link rel="stylesheet" href="css/classless.css">
	<link rel="stylesheet" href="css/themes.css">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<!-- Suppress form re-submit prompt on refresh -->
	<script>
		if (window.history.replaceState) {
			window.history.replaceState(null, null, window.location.href);
		}
	</script>
</head>

<body>
	<?php
	$max_upload = (int)(ini_get('upload_max_filesize'));
	$max_post = (int)(ini_get('post_max_size'));
	$memory_limit = (int)(ini_get('memory_limit'));
	$upload_mb = min($max_upload, $max_post, $memory_limit);
	if (file_exists('upload')) {
		shell_exec("rm -rf upload");
		mkdir('upload', 0777, true);
	}
	?>
	<div style="text-align: center;">
		<img style="display: inline; height: 2.5em; vertical-align: middle;" src="favicon.svg" alt="logo" />
		<h1 class="text-center" style="display: inline; margin-left: 0.19em; vertical-align: middle; letter-spacing: 3px; margin-top: 0em; color: #ffaaeeff;">EPUB Compiler</h1>
		<p style="color: lightgray; margin-bottom: 1.5em;">Current upload limit is <u><?php echo $upload_mb; ?>MB</u></p>
	</div>

	<div class="card">

		<form style="margin-top: 1em;" action=" " method="POST" enctype="multipart/form-data">
			<label for="fileToUpload">Select ZIP file:</label>
			<input style="margin-bottom: 1.5em; margin-top: 0.5em;" type="file" name="fileToUpload" id="fileToUpload">
			<button style="margin-bottom: 1.5em;" type="submit" name="compile">Compile</button>
		</form>

		<details>
			<summary style="letter-spacing: 1px; color: #ffaaeeff;">Help</summary>
			<ol>
				<li>
					Select the desired ZIP file using the <kbd>Browse</kbd> button.
				</li>
				<li>
					Press the <kbd>Compile</kbd> button.
				</li>
				<li>
					Download the resulting EPUB file.
				</li>
			</ol>
			<p class="text-center">EPUB Compiler is part of <a href="https://github.com/dmpop/bash-pubkit">Bash Pubkit</a></p>
		</details>
	</div>
	<p class="text-center"><?php echo $footer ?></p>
	<?php
	if (isset($_POST["compile"])) {
		$target_file = "upload/" . basename($_FILES["fileToUpload"]["name"]);
		$upload_ok = 1;
		$file_type = strtolower(pathinfo($target_file, PATHINFO_EXTENSION));
		if ($file_type != "zip" && $file_type != "ZIP") {
			$upload_ok = 0;
		}
		if ($upload_ok == 0) {
			echo "<script>";
			echo 'alert("Something went wrong. Make sure you upload a ZIP file that does not exceed the upload limit.")';
			echo "</script>";
		} else {
			if (move_uploaded_file($_FILES["fileToUpload"]["tmp_name"], $target_file)) {
				$f = 'upload/' . $_FILES["fileToUpload"]["name"];
				$dir = pathinfo($f, PATHINFO_FILENAME);
				$path = pathinfo(realpath($f), PATHINFO_DIRNAME);
				$zip = new ZipArchive;
				$res = $zip->open($f);
				if ($res === TRUE) {
					$zip->extractTo($path);
					$zip->close();
				}
				shell_exec("./compile.sh '" . $path . DIRECTORY_SEPARATOR . $dir . "'");
				ob_start();
				while (ob_get_status()) {
					ob_end_clean();
				}
				header('Content-type: file/epub');
				header('Content-Disposition: attachment; filename="upload/' . $dir . DIRECTORY_SEPARATOR . $dir . '.epub"');
				readfile("upload/" . $dir . DIRECTORY_SEPARATOR . $dir . ".epub");
			} else {
				echo "<script>";
				echo 'alert("Error uploading the file.")';
				echo "</script>";
			}
		}
	}
	?>
</body>

</html>