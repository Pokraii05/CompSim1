# Used by the workspace's Build LaTeX project recipe.
$pdf_mode = 1;

# Repair the legacy encoding fallback introduced by notebook exports.
for my $source (glob('*.tex')) {
    open my $input, '<:raw', $source or die "Cannot read $source: $!";
    my $original = do { local $/; <$input> };
    close $input;
    my $fixed = $original;
    $fixed =~ s/\\usepackage\[mathletters\]\{ucs\}\s*\\usepackage\[utf8x\]\{inputenc\}/\\usepackage[utf8]{inputenc}\n              \\DeclareUnicodeCharacter{03B2}{\\ensuremath{\\beta}}/g;
    next if $fixed eq $original;
    open my $output, '>:raw', $source or die "Cannot write $source: $!";
    print {$output} $fixed;
    close $output or die "Cannot close $source: $!";
    print "Fixed legacy nbconvert encoding in $source\n";
}
