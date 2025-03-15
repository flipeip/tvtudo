![TV Tudo Banner](/android/app/src/main/res/drawable-xhdpi/tv_banner.png)

# TV Tudo

A simple Brazilian TV player from a streaming site for Android TV, made with
Flutter.

## Motivation

My grandmother has difficulty with technology, and this project was made with
performance and ease of use in mind, different from other apps made for the
same purpose, which she finds difficult to use.

The idea behind it is to have easy access to the user's favorite channels,
with a simplified setup and even easier usability, demonstrating how a good
user experience should be in this category of TV streaming apps.

## Technical info

This app was made in an experimental way and without the purpose of being
something to be officially published, so *here be dragons*...

A small Dart script located at `bin/gerador_de_canais.dart` parses a request
from the streaming site, transforming it into the `lib/data/data/canais.dart`,
containing a list of the parsed channels.

This list is then used to show and customize the channels inside the app, and
gives the URL of where the channel is streamed, which is then shown inside a
WebView, after some hard-coded reverse-engineered procedures.

# Disclaimer

The source code of this application was developed solely for educational
purposes. All copyrights and trademarks mentioned or used in any way within this
application belong to their respective owners.

I, the app creator, declare that I have no affiliation or association with the
copyright holders of the mentioned brands. The use of the provided source code
is the sole responsibility of the user, and I disclaim any responsibility for
any misuse, losses, or consequences that may arise from the use of this code.

I recommend that users respect copyright laws and the usage guidelines of
registered trademarks, and that they use the source code in an ethical and
responsible manner.
