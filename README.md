# Fall Project

## Backstory

A few months ago I posted a link on my Facebook page to a "mix tape" of MP3s for my friends to check out. The link pointed to the public folder of my Dropbox account. Because I leave my Facebook posts completely open, knowing that someone could stumple onto this or a search engire could crawl it bothered me. I wondered if there was a simple way to limit the use of the link to just the people I wanted to access it.

## Objective

From this scenario was born the idea to have a link shorting service that would authenticate the users before passing the authorized people onto proper the "secured" location. If the person is not authorized to use the link, they are directed to a secondary location.

My goal was to implement this using Ruby on Heroku to handle the backend logic and use Facebook as the authentication service. The creators, friends, and link information would be stored within a database on Heroku and accessed via ActiveRecord.

## Workflow

The Link Owner - The person creating the link
1. Comes to the site and authenticates with their Facebook account.
1. Once authenticated the user's friends will be listed allowing them to check which ones they want to authorize.
1. They enter a URL for authorized users and another for unauthorized users.
1. The link is generated and ready for use.

Authorized User
1. Clicks on the link.
1. Asked to authenticate with their Facebook account.
1. Once authenticated, they are redirected to the URL for authorized users.

Unauthorized User
1. * Clicks on the link.
1. * Asked to authenticate with with Facebook account.
1. * Once authenticated, they are redirected to the URL for unauthorized users.

## What I learned

### Integration with Facebook

This was surprisingly easy. Turns out Heroku is currently the only cloud service that has partnered with Facebook. With just a few clicks they create a basic example web app that gets you up and moving. Most of the I needed for the Facebook part was already there.

### Using Haml

For me, Haml was kind of a pain. I spent an entire afternoon looking for information has how it handles forms. I ended up piecing it together was a lot of trial an error. For toting that they're easier and prettier than another technology, their web site lacked quite a bit of documentation that would have been useful for a newbie.


### Integrating the databases

This wasn't too difficult of a task once I understood how all the pieces fit togehter (belongs_to, has_many, etc). Where this became more difficult was when I tried pushing the code that was working locally onto Heroku.

### Heroku

From what I've seen so far, Heroku is a great service! The have things pretty documented, as I said before they Facebook intergration happening, it's relatively easy to use, and it's free. The problem I had was properly more around being a new user to the majority of this technology. When I pushed my code it, it wouldn't work initially. This was because I still was using the SQLite DB (which Heroku doesn't support) and not Postgres (which they do support). So I understood what I needed to do from their documentation, but there was some caveats. The majority of the time when ruby comes up, they're actually talking about Ruby on Rails, not plain ruby. So there was a strange error I was getting because I wasn't including the Rail gem. Their docs also state that they overwrite your database.yml file with their own settings so you're just up and going. This didn't happen for me. The app continued to use database.yml that I uploaded. I suspect this is because I wasn't placing it\reading it from the expected path with is probably standard for an actual Rails app.

## Notes

### Things to add

 - Sadly there was no tests created for this project. I ran out of time and wasn't quite sure how to automate Facebook authentication.

 - I would have really like to have created a better user intrface, but there were so many little things that stopped me dead in my tracks while trying to write this that I was never able to improve it.

 - Currently this app is in a VERY alpha stage. There's no SQL scrubbing, serious error checking, and there could probably be better logging to help with debugging. In general the app could be setup better to move from the local machines to production. I don't think this would be difficult to implement, but since it was the last stage of the project, I had no time to improve it.

### Things learned
 
Never think you're going to write an app using new technology in a short period.

