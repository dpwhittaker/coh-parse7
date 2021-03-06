meta:
  id: pigg
  file-extension: pigg
  endian: le
  encoding: ascii
  imports: ['messages', 'attrib_names', 'boostsets', 'classes', 'powercats', 'powersets', 'powers', 'origins', 'villain_def']
seq:
  - {id: magic, contents: [0x23, 0x1, 0,0]}
  - {id: version, type: u2}
  - {id: read_version, type: u2}
  - {id: archive_len, type: u2}
  - {id: file_len, type: u2}
  - {id: count, type: u4}
  - {id: value, type: file_header, size: file_len, repeat: expr, repeat-expr: count}
  - {id: strings, type: strings}
types:
  file_header:
    seq:
      - {id: magic, type: u4}
      - {id: name_id, type: u4}
      - {id: size, type: u4}
      - {id: timestamp, type: u4}
      - {id: offset, type: u4}
      - {id: reserved, type: u4}
      - {id: header_data_id, type: u4}
      - {id: checksum, size: 16}
      - {id: pack_size, type: u4}
    instances:
      key:
        value: _root.strings.value[name_id].value
      value: 
        size: pack_size
        pos: offset
        io: _root._io
        process: zlib
        type:
          switch-on: _root.strings.value[name_id].value
          cases:
            '"bin/clientmessages-en.bin"': messages
            '"bin/attrib_names.bin"': attrib_names
            '"bin/boostsets.bin"': boostsets
            '"bin/classes.bin"': classes
            '"bin/powercats.bin"': powercats
            '"bin/powersets.bin"': powersets
            '"bin/origins.bin"': origins
            '"bin/powers.bin"': powers
            '"bin/VillainDef.bin"': villain_def
            _: nothing
  nothing: {}
  strings:
    seq:
      - {id: smagic, contents: [0x89,0x67,0,0]}
      - {id: count, type: u4}
      - {id: len, type: u4}
      - {id: value, type: u4string, repeat: expr, repeat-expr: count}
  u4string:
    seq:
      - {id: len, type: u4}
      - {id: value, type: strz, size: len}