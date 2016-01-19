# Project 1 - Flicks

Flicks is a movies app using the [The Movie Database API](http://docs.themoviedb.apiary.io/#).

Time spent: **~20** hours spent in total

## User Stories

The following **required** functionality is complete:

- [x] User can view a list of movies currently playing in theaters from The Movie Database.
- [x] Poster images are loaded using the UIImageView category in the AFNetworking library.
- [x] User sees a loading state while waiting for the movies API.
- [x] User can pull to refresh the movie list.

The following **optional** features are implemented:

- [x] User sees an error message when there's a networking error.
- [ ] Movies are displayed using a CollectionView instead of a TableView.
- [x] User can search for a movie. (with case-insensitive)
- [x] All images fade in as they are loading.
- [ ] Customize the UI.

The following **additional** features are implemented:

- [x] Customize search bar's cancel button behavior
- [x] Customize search bar's clear button behavior
- [x] Add Launch Screen

## Video Walkthrough 

Here's a walkthrough of implemented user stories:


![ALT TEXT] (Flicks-1.gif)

GIF created with [LiceCap](http://www.cockos.com/licecap/).

## Notes

- There was a problem when installing CocoaPod which was the operating related problem and had to do the custom GEM_HOME to fix it.
- Xcode Source control's command "Discard All Changes" cause a problem by deleting the CocoaPods and I have to re-install the CocoaPods again.

## License

    Copyright 2016 Oranuch Tangdechavut

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
