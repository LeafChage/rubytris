module Rubytris
      module FieldStatus
            NONE = 0
            WALL = 1
            ACTIVE = 2
            FIX = 3
      end

      class Field
            WIDTH = 11
            HEIGHT = 20
            FINISH_COUNT = 40
            WALL_CHAR = "□ "
            BLOCK_CHAR = "■ "
            NONE_CHAR = "  "
            attr_reader :point

            def initialize()
                  @field = init_field
                  @point  = 0
            end

            def clear()
                  @field.each_with_index do |line, y|
                        line.each_with_index do |l, x|
                              @field[y][x] = 0 if l == FieldStatus::ACTIVE
                        end
                  end
            end

            def line_clear()
                  @field.each_with_index do |line, y|
                        if line == [FieldStatus::WALL, FieldStatus::FIX, FieldStatus::FIX, FieldStatus::FIX, FieldStatus::FIX, FieldStatus::FIX, FieldStatus::FIX, FieldStatus::FIX, FieldStatus::FIX, FieldStatus::FIX, FieldStatus::WALL]
                              @point += 1
                              @field.delete_at(y)
                              @field.insert(0, [FieldStatus::WALL, FieldStatus::NONE, FieldStatus::NONE, FieldStatus::NONE, FieldStatus::NONE, FieldStatus::NONE, FieldStatus::NONE, FieldStatus::NONE, FieldStatus::NONE, FieldStatus::NONE, FieldStatus::WALL])
                        end
                  end
            end

            def game_finish?()
                  @point >= 40
            end

            def are_block?(next_pos)
                  result = false
                  next_pos.each do |pos|
                        if is_block?(pos[0], pos[1])
                              result = true
                        end
                  end
                  result
            end

            def fix(now_pos)
                  now_pos.each do |pos|
                        @field[pos[1]][pos[0]] = FieldStatus::FIX
                  end
            end

            def pre_fix(now_pos)
                  now_pos.each do |pos|
                        @field[pos[1]][pos[0]] = FieldStatus::ACTIVE
                  end
            end

            def write()
                  text = "\n\e[25D"
                  @field.each do |line|
                        line.each do |l|
                              if l == FieldStatus::NONE
                                    text += NONE_CHAR
                              elsif l == FieldStatus::ACTIVE || l == FieldStatus::FIX
                                    text += BLOCK_CHAR
                              else
                                    text += WALL_CHAR
                              end
                        end
                        text += "\n\e[25D"
                  end
                  puts text
            end

            private
            def is_block?(x, y)
                  @field[y][x] == FieldStatus::WALL || @field[y][x] == FieldStatus::FIX
            end

            def init_field
                  f = []
                  HEIGHT.times do |i|
                        line = []
                        WIDTH.times do |j|
                              line[j] = (j == 0 || j == WIDTH - 1 || i == HEIGHT - 1) ? FieldStatus::WALL : FieldStatus::NONE
                        end
                        f[i] = line
                  end
                  return f
            end
      end

end

