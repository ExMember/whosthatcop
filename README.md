# WhosThatCop

Look up LAPD officers

[![Deploy](https://github.com/ExMember/whosthatcop/actions/workflows/pages.yml/badge.svg)](https://github.com/ExMember/whosthatcop/actions/workflows/pages.yml)
[![Hippocratic License HL3-CL-ECO-EXTR-LAW-SV-USTA](https://img.shields.io/static/v1?label=Hippocratic%20License&message=HL3-CL-ECO-EXTR-LAW-SV-USTA&labelColor=5e2751&color=bc8c3d)](https://firstdonoharm.dev/version/3/0/cl-eco-extr-law-sv-usta.html)

## How to use

1. Go to [WhosThatCop.com](https://whosthatcop.com).
2. Enter the serial number of an LAPD officer.
3. See information about that officer.

## Development

### Overview

WhosThatCop is a static site built with [Jekyll](https://jekyllrb.com).

LAPD roster data is included as CSV files in the `_data` directory.

A custom generator
([`LosAngelesPolice::Generator`](_plugins/los_angeles_police.rb)) uses that data
to generate a unique page for every officer on the roster.

JavaScript in the search form send users the officer's page when they enter
their serial number.

### Setup

1. Install Ruby ([version](.ruby-version)).
2. Install bundler. `gem install bundler`
3. Download the repository. `git clone git@github.com:ExMember/whosthatcop.git`
4. Install dependencies. `bundle install`

## Contributing

Contributions, issues, and feature requests are welcome!

I am especially interested in expanding to include other policing agencies. Send
me any publicly-available rosters and I will add them to the site.

## Acknowledgements

[Adrian Riskin](https://chez-risk.in) is responsible for making the LAPD roster
available to the public. He is a pioneer in records-based journalism.

[NN](https://twitter.com/NN35007) built the original [WhosThatCop Twitter
bot](https://twitter.com/WhosThatCop). When their bot was quickly (though
briefly) banned from Twitter, I decided the same functionality should be
available off of Twitter.

[GitHub Pages](https://pages.github.com)

[Jekyll](https://jekyllrb.com)

[USWDS](https://designsystem.digital.gov)

## Related projects

[Open Oversight](https://openoversight.lucyparsonslabs.com)

## Author

Damien Burke

- Twitter: [@ExMember](https://twitter.com/exmember)
- GitHub: [@ExMember](https://github.com/exmember)

## License

Copyright © 2022 [Damien Burke](https://github.com/exmember)

Licensed under the terms of the [Hippocratic License 3.0.](LICENSE.md)
