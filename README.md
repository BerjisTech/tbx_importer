# TBX (TermBase eXchange) Importer

[![Gem Version](https://badge.fury.io/rb/tbx_importer.svg)](https://badge.fury.io/rb/tbx_importer) [![Build Status](https://travis-ci.org/diasks2/tbx_importer.png)](https://travis-ci.org/diasks2/tbx_importer) [![License](https://img.shields.io/badge/license-MIT-brightgreen.svg?style=flat)](https://github.com/diasks2/tbx_importer/blob/master/LICENSE.txt)

This gem handles the importing and parsing of [.tbx files](http://www.ttt.org/oscarStandards/tbx/tbx_oscar.pdf). [TMX files](http://www.ttt.org/tbx/) are xml files.

## Installation

Add this line to your application's Gemfile:

**Ruby**  
```
gem install tbx_importer
```

**Ruby on Rails**  
Add this line to your application’s Gemfile:  
```ruby 
gem 'tbx_importer'
```

## Usage

```ruby
# Get the high level stats of a TBX file
# Including the encoding is optional. If not included the gem will attempt to detect the encoding.
file_path = File.expand_path('../tbx_importer/spec/sample_files/sample.tbx')
tbx = TbxImporter::Tbx.new(file_path: file_path)
tbx.stats
# => {:tc_count=>1, :term_count=>3, :language_pairs=>[["en", "fr"], ["en", "es"]]}

# Extract the segments of a TBX file
# Result: [term concepts, terms]
# term concepts = [tu_id, definition]
# terms = [tu_id, language, part_of_speech, term]

tbx.import
# => [[["6234-1457917153-1"], "the earth, together with all of its countries, peoples, and natural features.""], [["6234-1457917153-1", "en", "noun", world"], ["6234-1457917153-1", "fr", "noun", "monde"], ["6234-1457917153-1", "es", "noun", "mundo"]]]
```

## Contributing

1. Fork it ( https://github.com/diasks2/tbx_importer/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## License

The MIT License (MIT)

Copyright (c) 2016 Kevin S. Dias

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
