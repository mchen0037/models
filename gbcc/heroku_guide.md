
### heroku apps
list all the apps you have in heroku

### heroku apps:destroy <APPNAME>
deletes an app that you have

### heroku apps:create <APPNAME>
init heroku app, if you don't specify name then it will generate a name

### git push heroku master
pushes the repository onto heroku so that it will be on the web at <APPNAME>.herokuapp.com

### add existing repository to heroku remote
use this [link] (https://stackoverflow.com/questions/5129598/how-to-link-a-folder-with-an-existing-heroku-app#:~:text=To%20add%20your%20Heroku%20remote%20as%20a%20remote,Heroku%20project%20%28the%20same%20as%20the%20project.heroku.com%20subdomain%29.)
``` git remote add heroku git@heroku.com:project.git```

```heroku git:remote -a project```

