"""
This program generates passages that are generated in mad-lib format
a simple Madlips game written in python by imbamanhn :) 
"""

# The template for the story

STORY = "This morning %s woke up feeling %s. 'It is going to be a %s day!' Outside, a bunch of %ss were protesting to keep %s in stores. They began to %s to the rhythm of the %s, which made all the %ss very %s. Concerned, %s texted %s, who flew %s to %s and dropped %s in a puddle of frozen %s. %s woke up in the year %s, in a world where %ss ruled the world."

print 'mad lip game is here baby'
name = raw_input("Tell us your name baby chan: ")
adjective1 = raw_input('Enter the first adjective: ')
adjective2 = raw_input('Enter the second adjective: ')
adjective3 = raw_input('Enter the third adjective: ')

verb = raw_input('Enter a verb for us: ')

noun1 = raw_input('we gonna need the first noun: ')
noun2 = raw_input('we gonna need the second noun: ')

print 'next we are going to ask you some weird things ! so get ready :) '

animal = raw_input('plz choose an animal,we all like one ey: ')
food = raw_input('you like foods? then pick one hun: ')
fruit = raw_input('how about fruits? pick one too: ')
superhero = raw_input('how about those dum super heroes? give us a name: ')
country = raw_input('let us get to the country base: ')
desert = raw_input('dont tell me you like deserts too,which one: ')
year = raw_input('well lets get to know what year it is hmm: ')

print STORY % (name, adjective1, adjective2, animal, food, verb, noun1, fruit, adjective3, name,superhero, name, country, name, desert, name, year, noun2)
















