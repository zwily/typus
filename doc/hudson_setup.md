# Hudson Setup

These are the build steps in Hudson:

    bash -l -c "rvm use ruby-1.8.7-p330 && rm -f Gemfile.lock && bundle install && rake && rake DB=postgresql && rake DB=mysql"
    bash -l -c "rvm use ruby-1.9.2-p136 && rm -f Gemfile.lock && bundle install && rake && rake DB=postgresql && rake DB=mysql"
    bash -l -c "rvm use ree-1.8.7-2010.02 && rm -f Gemfile.lock && bundle install && rake && rake DB=postgresql && rake DB=mysql"
    bash -l -c "rvm use jruby-1.5.6 && rm -f Gemfile.lock && bundle install && rake && rake DB=postgresql && rake DB=mysql"

If builds the following branches:

    master
    3-0-stable

Max # of builds to keep:

    20

Options Set:

    ✓ Discard Old Builds:
    ✓ Trigger builds remotely (e.g., from scripts)
