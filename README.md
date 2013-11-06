# dirwatchtray

Use Case:
People using offlineimap or some other program which stores mail in maildir format, and who wish
to get a tray icon for new email.

## Functioning

dirwatchtray (dwt) is a very minimalistic executable which, given the path to a directory when run,
shows an icon in the system tray and watches the directory for changes.

 - if the directory contains files except "." and "..", the icon blinks
 - if the directory contains no files, the icon does not blink.

## State

*dwt* is extremely minimal (cloc reports 34 lines of code atm). There is no command line argument parsing
or anything fancy. There could also be some bugs, but I am confident no bug could cause harm
to your mail (no file IO is done except reading the directory listing). Still, this
software comes without warranty: Refer to the LICENSE file for the legal stuff.

## License

BSD-3, see LICENSE file.

## Howto

    cd dirwatchtray
    cabal configure   # install any missing dependencies mentioned
    cabal build
    cabal install
    cp no_mail.png ~  # or any other, prefered icon named no_mail.png

To run on linux systems, add these lines to you .xinitrc or .xsession
(depending on whether you use a login manager such as slim, gdm or run startx manually):

    killall dwt # to avoid dead dwt processes when relogging
    $HOME/.cabal/bin/dwt /path/to/maildir/INBOX/new &

*note* the end of the path ("/new") is important. Maildir saves unread, new mail in this directory,
they move somewhere else once read by a MUA. DWT simply watches the directory you give it, so if
you forget the /new part, it will never report new mails (or always report mails as new).

## Contributing

Sure, just open a pull request or send a patch file. I will try to respond timely.

You can also open bug reports or send ideas, but I cannot promise I will fix all bugs or
implement your idea. *dwt* basically works for me (tm) now.

## Ideas for Future

 - right clicking on icon shows config dialog
     - config dialog allows setting icon and blinking
 - multiple input directories (rather easy, just spawn multiple watchers)
 - play a sound when new mail arrives (set via config dialog?)
