#[macro_use]
extern crate ruru;
use ruru::{RString,Class,Object};

extern crate libc;
use libc::c_char;
use std::ffi::{CStr,CString};

mod rust {
  extern crate array_tool;
  use self::array_tool::string::Squeeze;
  use std::path::MAIN_SEPARATOR;

  static SEP: u8 = MAIN_SEPARATOR as u8;

  pub fn extract_last_path_segment(path: &str) -> &str {
    // Works with bytes directly because MAIN_SEPARATOR is always in the ASCII 7-bit range so we can
    // avoid the overhead of full UTF-8 processing.
    // See src/benches/path_parsing.rs for benchmarks of different approaches.
    let ptr = path.as_ptr();
    let mut i = path.len() as isize - 1;
    while i >= 0 {
      let c = unsafe { *ptr.offset(i) };
      if c != SEP { break; };
      i -= 1;
    }
    let end = (i + 1) as usize;
    while i >= 0 {
      let c = unsafe { *ptr.offset(i) };
      if c == SEP {
        return &path[(i + 1) as usize..end];
      };
      i -= 1;
    }
    &path[..end]
  }

  pub fn basename(pth: &str, ext: &str) -> String {
    // Known edge case
    // if &pth.squeeze("/")[..] == "/" { return "/".to_string(); }

    let mut name = extract_last_path_segment(pth);

    if ext == ".*" {
      if let Some(dot_i) = name.rfind('.') {
        name = &name[0..dot_i];
      }
    } else if name.ends_with(ext) {
      name = &name[..name.len() - ext.len()];
    };
    name.to_string()
  }
}

#[no_mangle]
pub extern "C" fn basename_with_pure_input(c_pth: *const c_char, c_ext: *const c_char) -> *const c_char {
  let pth = unsafe {
    assert!(!c_pth.is_null());
    CStr::from_ptr(c_pth).to_str().unwrap()
  };
  let ext = unsafe {
    assert!(!c_ext.is_null());
    CStr::from_ptr(c_ext).to_str().unwrap()
  };

  let name = rust::basename(pth, ext);

  CString::new(name).unwrap().into_raw()
}

#[no_mangle]
pub extern "C" fn basename_string_free(s: *mut c_char) {
  unsafe {
    if s.is_null() { return }
    CString::from_raw(s)
  };
}

#[no_mangle]
pub extern "C" fn basename_with_nil(c_pth: *const c_char, c_ext: *const c_char) -> *const c_char {
  if c_pth.is_null() || c_ext.is_null() {
    return c_pth;
  }
  let pth = unsafe { CStr::from_ptr(c_pth) }.to_str().unwrap();
  let ext = unsafe { CStr::from_ptr(c_ext) }.to_str().unwrap();

  let name = rust::basename(pth, ext);

  CString::new(name).unwrap().into_raw()
}

class!(RuruExample);

methods!(
  RuruExample,
  _itself,
  fn pub_basename(pth: RString, ext: RString) -> RString {
    RString::new(
      &rust::basename(
        pth.ok().unwrap_or(RString::new("")).to_str(),
        ext.ok().unwrap_or(RString::new("")).to_str()
      )[..]
    )
  }
);

#[allow(non_snake_case)]
#[no_mangle]
pub extern "C" fn Init_ruru_example(){
  Class::new("RuruExample", None).define(|itself| {
    itself.def("basename", pub_basename);
  });
}
