# sudo apt-get install ruby ruby-dev

# gem install bundler --user-install

# # add   to path 

# export PATH="/home/waves/.local/share/gem/ruby/3.0.0/bin:$PATH"

# bundle update

# #Your bundle requires a different version of Bundler than the one you're running.
# #Install the necessary version with `gem install bundler:2.3.27` and rerun bundler using `bundle _2.3.27_ update`



# #add the Jekyll gem to our Gemfile and install it to the ./vendor/bundle/ folder.
# bundle add jekyll

# #check jekyll version
# bundle exec jekyll -v


#OR...

https://jekyllrb.com/docs/installation/ubuntu/


sudo apt-get install ruby-full build-essential zlib1g-dev

echo '# Install Ruby Gems to ~/gems' >> ~/.bashrc
echo 'export GEM_HOME="$HOME/gems"' >> ~/.bashrc
echo 'export PATH="$HOME/gems/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc

gem install jekyll bundler
bundle update
bundle install

bundle exec jekyll serve --livereload
