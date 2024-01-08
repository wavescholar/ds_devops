sudo apt-get install ruby ruby-dev

gem install bundler --user-install

# add   to path 

export PATH="/home/waves/.local/share/gem/ruby/3.0.0/bin:$PATH"

bundle update
#add the Jekyll gem to our Gemfile and install it to the ./vendor/bundle/ folder.
bundle add jekyll

#check jekyll version
bundle exec jekyll -v
