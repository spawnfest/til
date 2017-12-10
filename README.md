# TILHUB

A hosted web application with support for any number of TIL spaces.

## Tech

This is a phoenix app. You can set it up as below:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  * Install Node.js dependencies with `cd assets && npm install`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## For the Judges :)

  This is a phoenix web app which aims to provide users with a personal space where they can post things that they have learnt.

  There are two ways to test this:

### The easy way

  This app has been setup at https://tilhub.in/

    1. Browse to https://tilhub.in/ in an anonymous browser window
    2. Click on the "Create TIL Now!" button
    3. Click on the "Take me to GitHub" button
    4. You should be taken to the GitHub authorization page. Click "Authorize minhajuddin"
    5. Now the app should do the following on your behalf
      1. Create a repository called `tilhub`
      2. Add a sample TIL post
      3. Publish your TIL home on http://yourusername.tilhub.in/
    6. Refresh the home page till you see the hello world post.
    7. Clicking on the title in the card should take you to the page which shows your TIL on TilHub
    8. Now, try adding a new post in GitHub or editing the existing hello world post.
    9. You should see your new/updated post in your til space http://yourusername.tilhub.in/

### The hard way
    1. Clone this repo and run the steps mentioned in ##Tech
    2. Create a GitHub oauth application at https://github.com/settings/applications/new
       Set the authorization callback in the GitHub app to http://localhost:4000/auth/github/callback
    3. Create a DNS entry in your `/etc/hosts` for `your_github_username.localhost` which points to 127.0.0.1
    4. Start your server using

            TH_GITHUB_CLIENT_ID="..." TH_GITHUB_CLIENT_SECRET="..." mix phx.server
    5. Now follow the steps mentioned in ### The easy way
