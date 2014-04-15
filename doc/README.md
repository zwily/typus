# Typus / Doc

## Generate Documentation

Install Sphinx:

    sudo easy_install pip
    sudo pip install Sphinx

Go to the guide:

    cd doc/user_guide

Build the docs:

    make html


## Releasing a new version

1. Update `version.rb`.
2. Update `CHANGELOG.md`.
3. Commit changes and run `rake release`.
4. Push documentation to <http://docs.typuscmf.com/>.
5. Notify the mailing list pasting a link diff between versions.
