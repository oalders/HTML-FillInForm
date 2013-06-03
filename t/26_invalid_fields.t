#!/usr/local/bin/perl

# contributed by Trevor Schellhorn

use strict;
use warnings FATAL => 'all';

use Test::More tests => 11;

use_ok('HTML::FillInForm');

my $html = qq[
<form>
<input type="text" name="one" value="all wrong">
<input type="text" name="two" class="existing" value="worse">
<input type="text" name="three" class="invalid" value="already bad">
<select name="four">
  <option value="1">Foo</option>
  <option value="2">Boo</option>
</select>
<textarea name="five"></textarea>
</form>
];

my $result =
  HTML::FillInForm->new->fill(scalarref      => \$html,
                              fdat           => {two => "new val 2"},
                              invalid_fields => ['one']);

like($result, qr/<input[^>]+name="one"[^>]+class="invalid"/);
unlike($result, qr/<input[^>]+name="two"[^>]+class="invalid"/);

$result = HTML::FillInForm->new->fill(scalarref      => \$html,
                                      fdat           => {two => "new val 2"},
                                      invalid_fields => ['one', 'two', 'three', 'four', 'five']);

like($result, qr/<input[^>]+name="one"[^>]+class="invalid"/);
like($result, qr/<input[^>]+name="two"[^>]+class="existing invalid"/);
like($result, qr/<input[^>]+name="three"[^>]+class="invalid"/);
like($result, qr/<select[^>]+name="four"[^>]+class="invalid"/);
like($result, qr/<textarea[^>]+name="five"[^>]+class="invalid"/);

$result = HTML::FillInForm->new->fill(scalarref      => \$html,
                                      fdat           => {two => "new val 2"},
                                      invalid_fields => ['one', 'three'],
                                      invalid_class  => "funky");

like($result, qr/<input[^>]+name="one"[^>]+class="funky"/);
like($result, qr/<input[^>]+name="two"[^>]+class="existing"/);
like($result, qr/<input[^>]+name="three"[^>]+class="invalid funky"/);
