<?php

$file = $argv[1];

if(!is_file($file))
	exit("Файла ($file) не существует\n");

// $file_content = file_get_contents($file);
// $file_content .= $argv[2] . "\n";
// file_put_contents($file, $file_content);

	$delay = mt_rand (0, 5);
	// $delay = 2;
	// echo "Delay: " . $delay . "\n";

	// sleep($delay);	

	if(unlink($file))
		exit();
		// exit("Файл ($file) - удален успешно\n");
	else
		exit("Ошибка удаления файла ($file)\n");