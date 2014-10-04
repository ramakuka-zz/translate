require "srt"

file_e = SRT::File.parse(File.new("/Users/Ram/Documents/Ruby/Translateit/trans/X-english.srt"))
file_h = SRT::File.parse(File.new("/Users/Ram/Documents/Ruby/Translateit/trans/X-hebrew.srt"))
english_subs = file_e.lines
hebrew_subs = file_h.lines
en_block = Hash.new
he_block = Hash.new
translation_map = Array.new

def check_match (src_arr,src_num_of_block,dst_arr,dst_num_of_block)
  for i in 0..src_num_of_block
    source_block_size =+ src_arr[i].end_time - src_arr[0].start_time
  end
  for m in 0..dst_num_of_block
    destenation_block_size =+ dst_arr[i].end_time - dst_arr[0].start_time
  end
return source_block_size,destenation_block_size
end

  def find_matched_block(src_arr,dest_arr)
  num_of_max_block_to_match = 3
  block_to_retrun = Hash.new
  block_to_retrun['source'] = Array.new
  block_to_retrun['destentation'] = Array.new
  src_counter=1
  dst_counter=1
  #Common Ground
  if (src_arr[0].start_time > dest_arr[0].start_time*0.9) && (src_arr[0].start_time < dest_arr[0].start_time*1.1)
    (1..num_of_max_block_to_match*2).each do |i|
      result = check_match(src_arr,src_counter-1,dest_arr,dst_counter-1)
      if (result[0]*0.9 < result[1]) && (result[0]*1.1 > result[1])
       block_to_retrun['source'] << src_arr[src_counter-1].sequence
       block_to_retrun['destentation'] <<  dest_arr[dst_counter -1].sequence
       break
      end
      if result[0] > result[1]*1.1
        block_to_retrun['destentation'] <<  dest_arr[dst_counter -1].sequence
        dst_counter += 1 
      end
      if result[1] > result[0]*1.1
        block_to_retrun['source'] << src_arr[src_counter-1].sequence
        src_counter += 1 
      end
    end
  end
  return block_to_retrun
end

def match_first_line(source_arr,destnation_arr)
  block_to_retrun = Hash.new
  block_to_retrun['source'] = Array.new
  block_to_retrun['destentation'] = Array.new
  #Lets make sure we have a common ground 
  if (source_arr[0].start_time > destnation_arr[0].start_time*0.9) && (source_arr[0].start_time < destnation_arr[0].start_time*1.1)
    source_blocksize = source_arr[0].end_time - source_arr[0].start_time  
    destentaion_blocksize = destnation_arr[0].end_time - destnation_arr[0].start_time
    ### In case Source Block fit to Destenation Blocks
    if (source_blocksize*0.9 < destentaion_blocksize) && (source_blocksize*1.1 > destentaion_blocksize)
       block_to_retrun['source'] << source_arr[0].sequence
       block_to_retrun['destentation'] <<  destnation_arr[0].sequence
    end
    
    ### In case Source Block fit to a few Destenation Blocks
    if source_blocksize > destentaion_blocksize*1.1
       block_to_retrun['source'] << source_arr[0].sequence
       block_to_retrun['destentation'] <<  destnation_arr[0].sequence
      #calculate the destenation block size
      (1..3).each do |i|
        destentaion_blocksize =  destnation_arr[i].end_time - destnation_arr[0].start_time
        if (source_blocksize*0.9 < destentaion_blocksize) && (source_blocksize*1.1 > destentaion_blocksize)
           block_to_retrun['destentation'] << destnation_arr[i].sequence
          break
        else 
          block_to_retrun['destentation'] << destnation_arr[i].sequence
        end
       end
     end
  end
  return block_to_retrun
end

def get_arr_location_from_seq(array,sequence)
  count = 0
  array_location = nil
  array.each do |line|
    if line.sequence == sequence
      array_location = count
      break
    end
    count += 1
 end
 return array_location
end

def delete_from_array(array,sequence)
 array.delete_at(get_arr_location_from_seq(array,sequence))
 return array 
end

(1..20).each do |m|
  translation_map[m] = Hash.new
  block =find_matched_block(english_subs,hebrew_subs)
  block['destentation'].each do |seq|
     term_arr = delete_from_array(hebrew_subs,seq)
     hebrew_subs = term_arr
 end
 block['source'].each do |seq|
     term_arr = delete_from_array(english_subs,seq)     
     english_subs = term_arr
 end
 translation_map[m]['source'] = block['source']
 translation_map[m]['destentation'] = block['destentation']
end

