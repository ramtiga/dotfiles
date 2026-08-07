<?php
/*
 * This document has been generated with
 * https://mlocati.github.io/php-cs-fixer-configurator/#version:3.11.0|configurator
 * you can change this configuration by importing this file.
 */
$config = new PhpCsFixer\Config();

return $config
    ->setLineEnding("\n")
    ->setRules([
        '@PSR2' => true,
        'assign_null_coalescing_to_coalesce_equal' => true,
        'binary_operator_spaces' => [
            'default' => 'single_space',
            'operators' => [
                '=>' => 'single_space',
                '=' => 'single_space',
            ],
        ],
        'blank_line_before_statement' => [
            'statements' => [
                'break',
                'case',
                'continue',
                'declare',
                'default',
                'do',
                'exit',
                'for',
                'foreach',
                'goto',
                'if',
                'include',
                'include_once',
                'phpdoc',
                'require',
                'require_once',
                'return',
                'switch',
                'throw',
                'try',
                'while',
                'yield',
                'yield_from',
            ],
        ],
        'cast_spaces' => true,
        'compact_nullable_typehint' => true,
        'constant_case' => true,
        'function_declaration' => true,
        'increment_style' => ['style' => 'post'],
        'list_syntax' => ['syntax' => 'short'],
        'lowercase_cast' => true,
        'no_unused_imports' => true,
        'no_useless_else' => true,
        'not_operator_with_successor_space' => true,
        'nullable_type_declaration_for_default_null_value' => ['use_nullable_type_declaration' => false],
        'ordered_imports' => ['sort_algorithm' => 'alpha'],
        'short_scalar_cast' => true,
        'simplified_if_return' => true,
        'single_line_comment_spacing' => true,
        'single_line_comment_style' => true,
        'standardize_increment' => true,
        'trailing_comma_in_multiline' => true,
    ])
    ->setFinder(
        PhpCsFixer\Finder::create()
            ->exclude('vendor')
            ->exclude('bootstrap/cache')
            ->exclude('storage')
            ->exclude('node_modules')
            ->in(__DIR__)
    )
;
