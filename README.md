# Bench Ruby FFI Example

This repository is an educational resource for examining the cost of
alternative ways in implementing type safety across Ruby & Rust FFI and
what performance gains you may have when implementing extra type guards
is not necessary.

### Ruby 2.4.2 & Rust 1.23.0-nightly

```
  Basename Comparison:
       Ruby's C impl:   661812.2 i/s
        through ruru:   652184.5 i/s - same-ish: difference falls within error
     with pure input:   492597.7 i/s - 1.34x  slower
      rust nil guard:   481088.2 i/s - 1.38x  slower
      ruby nil guard:   439570.8 i/s - 1.51x  slower
    with type safety:   375606.3 i/s - 1.76x  slower
```

## Plans

Implementations for Helix, FFI::AutoPointer, FFI::ManagedStruct, and Fiddle are planned.
Continuous integration through CodeShip is welcome as well.

## Contributing

There is much that can be learned about performance improvements when it comes to integrating
Rust and Ruby.  You're welcome to contribute to theis repository through issues and PRs.
Welcome additions include style & organization of code for clarity, alternative implementations
or new libraries to integrate.  Other ideas are welcome as issues.

# License

```
Bench Ruby FFI Example
Copyright (C) 2017  Daniel P. Clark

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
```
