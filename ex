from itertools import combinations

# Эта функция берет на вход строку-геном, делит его на подстроки-хромосомы и чистит от лишних символов(названий хромосом).
#На выходе получается список строк
def GenomeSplit(string):
    res= string.split('>chr')
    res.pop(0)
    count=0
    for substring in res:
        newstring = substring
        for symbol in substring:
            if symbol not in ["A","T","G","C"]:
                newstring= newstring.replace(symbol,"")
        res[count] = newstring
        count += 1
    return(res)
#Эта функция берет на вход строку и ищет в ней палиндромы
#На выход идет список из найденных палиндромов и положение первого символа палиндрома
def FindPolyndromes(substring):
    i=0
    j=6
    coordinates=[]
    for sequence in range(len(substring)):
        subseq= substring[i:j]
        if len(subseq) <6:
            continue
        i+=1
        j+=1
        count = 0
        n=0
        for nucleotide in subseq:
            n += -1
            if n == -4:
                break
            if nucleotide == subseq[n]:
                    count += 1
            elif  nucleotide == "A" or nucleotide == "T":
                if subseq[n] == "A" or subseq[n] == "T":
                    count += 1
            elif nucleotide == "G" or nucleotide == "C":
                if subseq[n] == "G" or subseq[n] == "C":
                    count += 1
            if count == 3:
                coordinates.append(subseq)
                coordinates.append(i)
    return (coordinates)
#Эта функция берет на вход список искомых палиндромов, список из палиндромов и их положений, а также список длин хромосом
#На выход идет список состоящий из списков длины отрезков. Относительно хромосом, списки расположены в том же порядке что и в оригиналном файле.
def CutPolyndrome(List_Of_Polyndromes,PolyndromeData,WholeLength):
    result =[]
    StringNumber = 0
    for list in PolyndromeData:
        RawLength = []
        i=0
        FinalLength = []
        UsedLength = 0
        for element in list:
            if element in List_Of_Polyndromes:
                RawLength.append(list[i+1])
            i += 1
        count = 0
        for num in RawLength:
            if count == 0:
                FinalLength.append(num)
                UsedLength += num
                count += 1
            else:
                dif = num - UsedLength
                if dif > 6:
                    FinalLength.append(dif)
                    UsedLength += dif
                count += 1
        FinalLength.append(WholeLength[StringNumber]-UsedLength)
        result.append(FinalLength)
        StringNumber += 1
    return(result)
# Эта функция берет на вход заданные длины, список из палиндромов и их положений, а также список длин хромосом.
# Она генерирует из имеющихся в геноме палиндромов сочетания без повторений и подает на вход функции CutPolyndrome
# На выход подается либо список подходящих палиндромов, либо сообщение о том, что подходящего набора ферментов нет.
def CalculatePolyndrome(lengths, PolyndromeData,WholeLength):
    UniquePolyndromes = []
    for list in PolyndromeData:
        for i in range(0,len(list),2):
            UniquePolyndromes.append(list[i])
    UniquePolyndromes= set(UniquePolyndromes)
    for j in range(1,6):
        if j == 5:
            result ='Подходящего набора ферментов не найдено'
            break
        FinalCheck = 0
        for polyndrome in combinations(UniquePolyndromes,j):
           Prototype = CutPolyndrome(polyndrome,PolyndromeData,WholeLength)
           ListCheck = 0
           print(polyndrome)
           for list in Prototype:
               if list == []:
                   break
               NumCheck=0
               for num in list:
                   for value in lengths:
                       if value+20 > num > value -20:
                           NumCheck += 1
                           break
               if NumCheck == len(list):
                   ListCheck += 1
                   continue
               else:
                   break
           if ListCheck == len(Prototype):
               FinalCheck +=1
               break
        if FinalCheck == 1:
            result = polyndrome
            print
            break
    return(result)

print('Введите абсолютный путь до файла')
path = str(input())
text = open(path)
genome=text.read()
print('Введите 1, если хотите по заданным палиндромам узнать набор длин фрагментов. Введите 2 если хотите по заданным длинам определить типы рестриктаз')
a=int(input())

if a == 1:
    print('Введите палиндромы через пробел')
    PolyList = [str(i) for i in input().split()]
    PlaceList = []
    List_of_substrings = GenomeSplit(genome)
    WholeLength = []
    for substrings in List_of_substrings:
        poly = FindPolyndromes(substrings)
        PlaceList.append(poly)
        WholeLength.append(len(substrings))
    print(CutPolyndrome(PolyList,PlaceList,WholeLength))
if a ==2:
    print("Введите длины через пробел")
    LenList= [int(i) for i in input().split()]
    PlaceList = []
    List_of_substrings = GenomeSplit(genome)
    WholeLength = []
    for substrings in List_of_substrings:
        poly = FindPolyndromes(substrings)
        PlaceList.append(poly)
        WholeLength.append(len(substrings))
    print(CalculatePolyndrome(LenList, PlaceList, WholeLength))
