require "ffi_example/version"
require "ffi"

module FfiExample
  def self.basename_with_pure_input(pth, ext = '')
    Rust.basename_with_pure_input(pth, ext)
  end

  def self.basename_nil_guard(pth, ext = '')
    return nil if pth.nil? || ext.nil?
    Rust.basename_with_pure_input(pth, ext)
  end

  def self.basename_with_nil(pth, ext = '')
    Rust.basename_with_nil(pth, ext)
  end

  def self.file_basename(pth, ext = '')
    pth = pth.to_path if pth.respond_to? :to_path
    raise TypeError unless pth.is_a?(String) && ext.is_a?(String)
    Rust.basename_with_pure_input(pth, ext)
  end

  def self.basename_with_auto_pointer(pth, ext = '')
    Rust::Basename::Binding.generate(pth, ext)
  end

  # Begin Fiddle
  require 'fiddle'
  library = Fiddle.dlopen(
    begin
      prefix = Gem.win_platform? ? "" : "lib"
      "#{File.expand_path("../target/release/", __dir__)}/#{prefix}ffi_example.#{FFI::Platform::LIBSUFFIX}"
    end
  )
  Fiddle::Function.
    new(library['Init_ruru_example'], [], Fiddle::TYPE_VOIDP).
    call
  # End Fiddle

  module Rust
    extend FFI::Library
    FFI_LIBRARY = begin
      prefix = Gem.win_platform? ? "" : "lib"
      "#{File.expand_path("../target/release/", __dir__)}/#{prefix}ffi_example.#{FFI::Platform::LIBSUFFIX}"
    end
    ffi_lib FFI_LIBRARY

    attach_function :basename_with_pure_input, [ :string, :string ], :string
    attach_function :basename_with_nil, [ :string, :string ], :string

    class Basename < ::FFI::AutoPointer
      def self.release(ptr)
        Binding.free(ptr)
      end

      def self.to_s
        @str ||= self.read_string.force_encoding('UTF-8')
      end

      module Binding
        extend FFI::Library
        ffi_lib FfiExample::Rust::FFI_LIBRARY

        attach_function :generate, :basename_with_nil, [:string, :string], Basename
        attach_function :free, :basename_string_free, [Basename], :void
      end
    end
  end
  private_constant :Rust
end
