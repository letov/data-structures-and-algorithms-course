<?php

include __DIR__ . '/vendor/autoload.php';

$text = file_get_contents(__DIR__ . '/dataset');
$text = str_replace("\n", "", $text);
$words = explode(" ", $text);
$words = array_map(function($word) {
    $word = preg_replace( "/[^a-zA-Z\s]/", '', $word);
    return strtolower($word);
}, $words);
$exactlyCount = count(array_unique($words));
$logLog = new HyperLogLog\Basic();
foreach ($words as $word) {
    $logLog->add($word);
}
$loglogCount = $logLog->count();
echo 'word count: ' . count($words) . PHP_EOL;
echo 'exactly uniq count: ' . $exactlyCount . PHP_EOL;
echo 'hyperLogLog count: ' . $loglogCount . PHP_EOL;
echo 'error: ' . number_format(($loglogCount - $exactlyCount) / ($exactlyCount / 100.0), 3) . '%' . PHP_EOL;