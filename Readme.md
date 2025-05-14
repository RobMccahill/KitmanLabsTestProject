# Kitman Labs Test Project

Just giving a few notes on the project structure and what I focused on:

- I used SwiftUI since I've found it's handy for prototyping, and I've used a view model where I think it's relevant for the login and athletes list screen.

- For network requests I'm using a small `HTTPClient` class for making / receiving requests, and for handling JSON parsing and date formatting

- Each request made has a relevant `service` class, which is a light protocol for abstracting away the underlying call, and that's passed into the view models.

- For dependencies and passing things around, there's an `AppSession` class which holds relevant dependencies, and it's attached to the Swift UI App instance. The app will handle the state for logging in, and for navigating to the list and detail views as well.

- I didn't get round to testing, since I wanted to focus on the views themselves. If I were to start, I'd look at the view models and write tests for things like various states (errors, no athletes returned), and checking the search functionality and being able to filter by squad. Since the view model is detached from the view, and the service is behind a protocol, it should be manageable enough to isolate the view model and to re-create any scenarios needed.
