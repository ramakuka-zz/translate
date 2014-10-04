require_relative  "Trans_tools.rb"
source = Tobject.new(File.new("/Users/Ram/Documents/Ruby/Translateit/trans/X-english.srt"))
dst = Tobject.new(File.new("/Users/Ram/Documents/Ruby/Translateit/trans/X-hebrew.srt"))

translation = Translate.new
5.times {
  src_block,dst_block = translation.get_block_transation(source,dst)
  source.delete_blocks(src_block)
  dst.delete_blocks(dst_block)
}

