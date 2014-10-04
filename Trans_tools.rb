require "srt"
class Tobject

  include SRT
  def initialize (*args)
    @srt = SRT::File.parse(*args)
  end
   
  def get_index_from_seq(sequence)
    @srt.lines.each_with_index { |line,index| 
      return index if line.sequence == sequence
       }
  end
  def get_sequnce_from_index(index)
    return @srt.lines[index].sequence
  end
  
  def get_start_time(index=0)
    return @srt.lines[index].start_time
  end
  
  def get_block_size(index,range)
    return (@srt.lines[index].end_time - @srt.lines[0].start_time ) if range !=0   
    return (@srt.lines[index].end_time - @srt.lines[index].start_time)  
  end
  
  def delete_block(sequence)
      @srt.lines.delete_at(get_index_from_seq(sequence))
  end
  
  def delete_blocks(seq)
    @srt.lines.each { |line|
      if line.sequence <= seq
       @srt.lines.delete_at(get_index_from_seq(line.sequence))
      elsif line.sequence > seq
        break
      end
     } 
  end
  
 def get_closest_start_time(starttime)
   @srt.lines.each {|line|
      return line.sequence if ((line.start_time < starttime*1.1) && (line.start_time > starttime*0.9))
     }
 end
 
 def get_common_ground(object)
   @srt.lines.each {|line|
     return line.sequence if object.get_closest_start_time(line.start_time)
     }
 end
 
end

class Translate 
   
  def initialize
    @trans ||= []
  end
   
   def get_block_transation(src_object,dst_object)
   max_block_to_try =3
   source_index = 0 
   dst_index = 0
   (max_block_to_try*2).times { |index|
      if (src_object.get_block_size(source_index,1)*0.9 < dst_object.get_block_size(dst_index,1)) && (src_object.get_block_size(source_index,1)*1.1 > dst_object.get_block_size(dst_index,1))
        @trans << {:source => "aa", :dst => "bb"}
        return src_object.get_sequnce_from_index(source_index),dst_object.get_sequnce_from_index(dst_index)
      elsif (src_object.get_block_size(source_index,1)*1.1 < dst_object.get_block_size(dst_index,1))
        source_index += 1
      elsif (src_object.get_block_size(source_index,1)*0.9 > dst_object.get_block_size(dst_index,1))
        dst_index += 1
      end
   }
   return -1,-1
 end
end