# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl Password-Check.t'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use Test::More tests => 7;
BEGIN { use_ok('Data::Password::Check') };

#########################

# Insert your test code below, the Test::More module is use()ed here so read
# its man page ( perldoc Test::More ) for help writing this test script.

# This test file uses the default setup, and just pokes to make sure that we get failures
# when we expect them

my ($pwcheck);

# list of passwords and expected errors
my @tests = (
	# qwerty should be rejected as a silly word
	{
		'password'	=> 'qwerty',
		'error_msg'	=> qr{^You may not use 'qwerty' as your password$},
	},
	# a should be too short
	{
		'password'	=> 'a',
		'error_msg'	=> qr{^The password must be at least \d+ characters$},
	},
	# xxxxxx is repeated - which is bad
	{
		'password'	=> 'xxxxxx',
		'error_msg'	=> qr{^You cannot use a single repeated character as a password$},
	},
);

# run each test in turn, lokk for errors, and make sure they match what we expect
foreach my $test (@tests) {
	# check the password
	$pwcheck = Data::Password::Check->check({ 'password' => $test->{'password'} });
	# make sure we have an error
	ok($pwcheck->has_errors());
	# make sure we have an appropriate error message
	ok($pwcheck->error_list()->[0] =~ /$test->{'error_msg'}/);
}
