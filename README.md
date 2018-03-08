# Sm808

```
      ::::::::    :::   :::    ::::::::   :::::::   ::::::::
    :+:    :+:  :+:+: :+:+:  :+:    :+: :+:   :+: :+:    :+:
   +:+        +:+ +:+:+ +:+ +:+    +:+ +:+   +:+ +:+    +:+
  +#++:++#++ +#+  +:+  +#+  +#++:++#  +#+   +:+  +#++:++#
        +#+ +#+       +#+ +#+    +#+ +#+   +#+ +#+    +#+
#+#    #+# #+#       #+# #+#    #+# #+#   #+# #+#    #+#
########  ###       ###  ########   #######   ########
```

An implementation of [https://github.com/splicers/sm-808](sm808) in ruby.

## Table of Contents

* [Domain Modeling](#domain-modeling)
* [Considerations](#considerations)
* [Future Additions](#future-additions)
* [Installation](#installation)
* [Usage](#usage)
* [Development](#development)
* [Contributing](#contributing)
* [License](#license)
* [Copyright](#copyright)

## Modeling

Proving some context around the decisions involving terminology & domain modeling.

### Drum Machine

The drum machine orchestrates the playback and sampling of a song containing sequenced patterns of steps for supported output interfaces.

_Given that the 808 is a drum machine, I think I'd be remiss not to have a drum machine in the project._

### Song

A song is responsible for sequencing multiple patterns for different samples.
It uses an external iterator, that I called a `StepCounter` to keep track of the "next step".

_This came in handy, especially when implementing looping, playback, and the augmenting of pattern durations._

### Pattern

A pattern is a sequence of steps for a particular sample.
The pattern's steps are activated/deactivated to simulate notes/rests for a sample.

_At some point I called this a "sample", but that didn't fit because a sample is a sound, and this is more about the pattern describing when the sample makes sound._

### Step

A step is the primitive unit of time used to construct patterns.
A step is either active or inactive, serving as either a rest or a note in the pattern.
I found this to be the most difficult entity to name.

_Initially I wanted to call it a "note", but that didn't feel right because you wouldn't refer to a "rest" as a "note" (at least in my experience)._

### Sample

A sample is a named sound.

_This ended up only surfacing in the domain as "name". I thing as the drum machine gets more sophisticated, this would turn into a thing with more behavior._

### Interfaces

When I think of drum machines, I immediately think of output interfaces such as MIDI.

_This abstraction ended up being a good way to support web, cli and even a test interface, specificly for automated tests._

## Considerations

Some context around the technical decisions made.

### Dependencies / Known Inadequacies

While this was fun, I can't imagine anyone choosing ruby to implement a real drum machine :P
I chose ruby because it's the language/community I know best.

Immediately after reading the project description, I was already thinking about user interactivity.
When I envision a drum machine, I'm usually picturing a person adjusting configurations while it plays in a loop.

Realizing in order to support user interaction, I'd need to think a bit about concurrency.
I really wanted an excuse to play with the admittedly arcane `DRb` library, given the toy nature of the project.
While I did get a version of it working, I ended up scrapping it.

Instead, I opted to for a minimal web socket server and client, handling the server side event scheduling using Event Machine timers.
I tried to write as little UI code as possible since it's not really the focus of the exercise.

### Interactivity

Prior to deciding to implement the web interface, I had been toying around with [curses](https://github.com/ruby/curses).
I've always been intrigued by the concept of command line based GUIs.
I thought this would be a cool fit due to the already retro nature of the 808.
While I did some visualization working, I found it difficult to manage user interaction.
For the sake of time, I decided to switch to the more familiar (to me) web environment.

## Future Additions

Honestly, I think drum machines, or really any music creation hardware, are super cool.
I know I could lost noodling on things for a long time.
That said, I need to cut myself off from the fun at some point.
Here's some categories of future improvements that would be neat to work on.

* Html5 Audio API usage
* Ability to drag/select over steps like most modern beat creation tools
* Thread based concurrency approach
* More dynamically constructed interface using the settings of the drum machine.

## Demo

![sm_808](/sm_808.gif?raw=true)

## Installation

If you really want to, there's nothing stopping you from adding this to your application's Gemfile:

```ruby
gem 'sm_808'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install sm_808

## Usage

```
./bin/sm_808 # Please see -h for more specific options
```

## Development

After checking out the repo, run `bin/setup` to install dependencies.
Then, run `rake spec` to run the tests.
You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/tonywok/sm_808.
This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Sm808 project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/tonywok/sm_808/blob/master/CODE_OF_CONDUCT.md).
