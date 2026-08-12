<?php

declare(strict_types=1);

namespace PHPStanRules;

use PhpParser\Node;
use PHPStan\Analyser\Scope;
use PHPStan\Rules\Rule;
use PHPStan\Rules\RuleErrorBuilder;

/**
 * @implements Rule<Node\Stmt>
 */
final class RequireStrictTypesRule implements Rule
{
    public function getNodeType(): string
    {
        return Node\Stmt::class;
    }

    public function processNode(Node $node, Scope $scope): array
    {
        static $checked_files = [];

        $file_path = $scope->getFile();

        if (isset($checked_files[$file_path])) {
            return [];
        }

        $checked_files[$file_path] = true;

        $contents = file_get_contents($file_path);

        if ($contents === false) {
            return [];
        }

        if (preg_match('/declare\s*\(\s*strict_types\s*=\s*1\s*\)\s*;/', $contents) === 1) {
            return [];
        }

        return [
            RuleErrorBuilder::message(
                'ファイルの先頭に declare(strict_types=1); がありません。',
            )
                ->identifier('phpFile.missingStrictTypes')
                ->build(),
        ];
    }
}
