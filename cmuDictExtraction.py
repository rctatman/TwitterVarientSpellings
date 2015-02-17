# creates a new file
dicByFreq = open("dicByFreq.txt", "w")

# opens existing file in same directory. You will need a copy of the CMU pronouncing dictionary, avabile here: 
# http://www.speech.cs.cmu.edu/cgi-bin/cmudict
# freqTop100.txt is avalible in this repo.
dic = open("cmudict-0.7b.txt", "r")
freq = open("freqTop100.txt", "r")
# this prevents us from having to go back to the beginning of the file in every loop.
dic = dic.readlines()

# Takes the word from the frequency file, then looks for it in the CMU dictionary, including variants.
# Appends the dictionary entry to our new file.

for line in freq:
    end = line.index("\n")
    name = line[0:end]
    for entry in dic:
        if entry.startswith(name.upper()+" "):
            newline = entry
            dicByFreq.write(newline)
        if entry.startswith(name.upper()+"("):
            newline = entry
            dicByFreq.write(newline)

# closes your new file with all the info you extracted
dicByFreq.close()
