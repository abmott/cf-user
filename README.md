# cf-user

These tools can be used to manage users and spaces on a PCF environment.

To use the tools you must be logged into a CF environment. Verify target with "cf target", target space does not matter, just organization
an update will come that will allow the tool to target an organization.

Each tool does a part of the puzzle.

Newuser.rb will create a user account, generate a password and assign a space to the user.

Spacerole.rb will allow a user to be added to a space with a space role.

getuser.rb will save all the users for the environment to individual files for reference or audit purposes.

showuser.rb will output the users for the enviornment to the console.

createduser.txt is where the new user account information is written to reference after the script is run.
'# cf-user' is not a registered command. See 'cf help'
