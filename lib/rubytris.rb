require "rubytris/version"
require 'io/console'
require 'rubytris/field'
require 'rubytris/current'

module Rubytris
      extend self
      def display_clear()
            print "\x1b[2J\x1b[0;0H"
      end

      def fall_to_block(current, field)
            result = current
            loop do
                  next_pos = result.fall.move_position
                  if field.are_block?(next_pos)
                        return result
                  else
                        result = result.fall
                  end
            end
      end

      def tetris()
            display_clear()

            field = Field.new()
            field.write()

            current = Current.new(5, 0)

            cmd = 'n'
            thread = Thread::start do
                  while (cmd = STDIN.getch)
                        if cmd ==  "\C-c"
                              break
                        end
                  end
            end
            loop do
                  sleep(0.2)
                  self.display_clear()
                  puts "left: f, right: j, rotate: space, q: exit \e[25D"
                  puts "\e[25D#{field.point}\e[25D"
                  case cmd
                  when 'q' then
                        exit()
                  when 'f' then
                        tmp = current.left
                  when 'j' then
                        tmp = current.right
                  when 'b' then
                        tmp = self.fall_to_block(current, field)
                  when ' ' then
                        tmp = current.rotation
                  else
                        tmp = current.fall
                  end
                  next_pos = tmp.move_position

                  if !field.are_block?(next_pos)
                        field.pre_fix(next_pos)
                        current = tmp
                  elsif cmd != 'n'
                        current = current
                  else
                        field.fix(current.move_position)
                        current = Current.new(5, 0)
                        next_pos = current.move_position
                        if field.are_block?(next_pos)
                              puts "game over"
                              break
                        end
                  end
                  field.write
                  field.clear
                  field.line_clear
                  cmd = 'n'
                  if field.game_finish?()
                        puts "success!!!!!!"
                        break
                  end
            end
            Thread.kill(thread)
      end
end
