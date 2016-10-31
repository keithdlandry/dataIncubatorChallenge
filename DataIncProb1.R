#traverse all possible rolls by moving one over each time
#

findRolls <-function(arr, pos, N, M, probs){
		
	n <- arr[pos]
	s <- 0
	for (i in 1:n){
		for (j in 1:6){
			s <- s + arr[j]*j
		}
		#s <- M
		if (s == M){
			#print(i)
			#print(pos)
			#print(arr)
			p <- 1
			for (j in 1:6){
				if (arr[j] > 0){
					p <- p * j^arr[j]
				}
			}
			prodArray <<- c(prodArray, p)
			probArray <<- c(probArray, dmultinom(arr,prob = probs))
			numberArray <<- c(numberArray, dmultinom(arr,prob = probs)*6^N)
		}
		
		if (pos != 6){		
			arr[pos]   <- arr[pos] - 1
			arr[pos+1] <- arr[pos+1] + 1
			findRolls(arr, pos+1, N, M, probs)
		}
	}
}



N = 50  
M = 150 #sum of N rolls

#start with all N rolls a 1 and itterate through all combos with findRolls
startArr <-c(N,0,0,0,0,0)
probs <- c(1/6,1/6,1/6,1/6,1/6,1/6)
prodArray <- vector()	#store product of roll
probArray <- vector()   #store the prob of each roll
numberArray <- vector() #store number of rolls that end up at sum of M

findRolls(arr = startArr, pos = 1, N = N, M = M, probs = probs)
probArray <- probArray/(sum(numberArray)/6^N) #bayes theorm to find actual probabilities
probArray
sum(probArray)
expectedProd <- sum(prodArray*probArray)
numberArray
expectedProd
sprintf("%.10f",expectedProd)

stdDev <- sqrt(sum(probArray*(prodArray-expectedProd)^2))
sprintf("%.10f",stdDev)
