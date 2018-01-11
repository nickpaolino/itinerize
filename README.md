## Overview

Revelize is a multiple-page Ruby on Rails web app that allows users to vote on
venues for their plans. The front-end is written without any JavaScript,
utilizing embedded Ruby files (ERB) and Rails helper methods. The user
authentication is implemented using cookies.

## Technology

Revelize uses Rails 5 with Postgres in the MVC pattern. It has no JavaScript and
so the Rails views are responsible for all of the front-end work. The user
authentication implements a sessions controller along with a cookie that's
stored in the user's browser to authenticate on refresh.

## Functionality

There are four stages of the application's process. The first is where users
create an event and invite friends. The second stage requires users to add
potential venues for the event. The third has users vote on which venue is most
suitable for their plans and the fourth, after the deadline is up, displays the
venues the received the most votes. At any stage in the process a user can
switch between the first, second, and third stage. When the time deadline is up,
however, a user can no longer create venues, vote, or invite friends and remains
fixed at the last stage.

Implementing this without any use of JavaScript state management required the
heavy use of cookies to determine which stage in the venue voting process a user
is at for each event. When a user logs in and clicks on an event, the browser
knows which stage that user is at in the voting process. If the time is up for
voting, all users are sent to the results page.
