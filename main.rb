#!/usr/bin/env ruby
require_relative './editor'

user_input = (STDIN.tty?) ? 'not reading from stdin' : $stdin.read

puts text_editor(user_input)
