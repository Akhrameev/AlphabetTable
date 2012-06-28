Pod::Spec.new do |s|
  s.name     = 'AlphabetTable'
  s.version  = '0.0.1'
  s.license  = 'MIT'
  s.summary  = 'A UITableView subclass which automatically sorts your data elements into sections keyed by letter'
  s.homepage = 'https://github.com/idottv/AlphabetTable'
  s.author   = { 'Bryce Redd' => 'bryce@i.tv' }

  # Specify the location from where the source should be retreived.
  #
  s.source   = { :git => 'git@github.com:idottv/AlphabetTable.git', :tag => '0.0.1' }

  s.description = 'A UITableView subclass which automatically sorts your data elements into sections keyed by letter.  Also supports searching'

  # If this Pod runs only on iOS or OS X, then specify that with one of
  # these, or none if it runs on both platforms.
  #
  s.platform = :ios

  # A list of file patterns which select the source files that should be
  # added to the Pods project. If the pattern is a directory then the
  # path will automatically have '*.{h,m,mm,c,cpp}' appended.
  #
  # Alternatively, you can use the FileList class for even more control
  # over the selected files.
  # (See http://rake.rubyforge.org/classes/Rake/FileList.html.)
  #
  s.source_files = 'ITVAlphabetTableView.{h,m}'

  # A list of resources included with the Pod. These are copied into the
  # target bundle with a build phase script.
  #
  # Also allows the use of the FileList class like source_files does.
  #
  # s.resource = "icon.png"
  # s.resources = "Resources/*.png"

  # A list of paths to remove after installing the Pod without the
  # '--no-clean' option. These can be examples, docs, and any other type
  # of files that are not needed to build the Pod.
  #
  # *NOTE*: Never remove license and README files.
  #
  # Also allows the use of the FileList class like source_files does.
  #
  # s.clean_path = "examples"
  # s.clean_paths = "examples", "doc"

  # Specify a list of frameworks that the application needs to link
  # against for this Pod to work.
  #
  # s.framework = 'SomeFramework'

  # Specify a list of libraries that the application needs to link
  # against for this Pod to work.
  #
  # s.library = 'iconv'
  # s.libraries = 'iconv', 'xml2'

  # If this Pod uses ARC, specify it like so.
  #
  s.requires_arc = true

  # If you need to specify any other build settings, add them to the
  # xcconfig hash.
  #
  # s.xcconfig = { 'HEADER_SEARCH_PATHS' => '$(SDKROOT)/usr/include/libxml2' }

end

