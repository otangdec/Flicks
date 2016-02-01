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
- [x] Customize the UI.

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
    

# Project 2 - Flicks

Flicks is a movies app displaying box office and top rental DVDs using [The Movie Database API](http://docs.themoviedb.apiary.io/#).

Time spent: **X** hours spent in total

## User Stories

The following **required** functionality is completed:

- [x] User can view movie details by tapping on a cell.
- [x] User can select from a tab bar for either **Now Playing** or **Top Rated** movies.
- [x] Customize the selection effect of the cell.

The following **optional** features are implemented:

- [x] For the large poster, load the low resolution image first and then switch to the high resolution image when complete.
- [x] Customize the navigation bar.

The following **additional** features are implemented:

- [x] Add search bar into the navigation bar, toggle show/hide by tap on a search icon
- [x] Adjust the information view to fit contents height
- [x] The information view can be toggle show/hide
- [x] customize tab bar
- [x] customize information for movie cell

Please list two areas of the assignment you'd like to **discuss further with your peers** during the next class (examples include better ways to implement something, how to extend your app in certain ways, etc):

1. Creating class to handle information
2. The best practice to implement more than 1 API call

## Video Walkthrough 

Here's a walkthrough of implemented user stories:

<img src='https://github.com/otangdec/Flicks/blob/master/Flicks-2.gif' title='Week 2 Flicks Walk Through' width='' alt='Video Walkthrough' />

GIF created with [LiceCap](http://www.cockos.com/licecap/).

## Notes

Optional and unwrapping are still complicated and not easy to wrap my head around it.
Need to get used to look up the Swift documentation

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
