drew = User.create(name: "Drew", email: "drew@drew.com", password: "password")
alec = User.create(name: "alec",email: "alec@alec.com", password: "password")


ProjectIdea.create(content: "Im going to make an app for nearby resturants!", user_id: drew.id)
ProjectIdea.create(content: "Im going to make an app for musicians!", user_id: alec.id)


drew.project_ideas.create(content: "We have many project ideas!")
