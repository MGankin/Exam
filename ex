text = open(r'C:\Users\Arashi\Downloads\Telegram Desktop\genome.fna')
genome=text.read()
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
#Эта функция берет на вход список искомых палиндромов и список из результатов предыдущей функции
#На выход идет список состоящий из списков длины отрезков. Относительно хромосом, списки расположены в том же порядке что и в оригиналном файле.
def CutPolyndrome(List_Of_Polyndromes,PolyndromeData):
    result =[]
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
                FinalLength.append(num+1)
                UsedLength += num
                count += 1
            else:
                dif = num - UsedLength
                if dif > 6:
                    FinalLength.append(dif+1)
                    UsedLength += dif
                count += 1
            if num == RawLength[len(RawLength)-1] and len(FinalLength) == 1:
                FinalLength.append(num - FinalLength[0])
        result.append(FinalLength)
        print(result)

    return(result)

def CalculatePolyndrome(lengths, PolyndromeData):
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
           Prototype = CutPolyndrome(polyndrome,PolyndromeData)
           print(polyndrome)
           ListCheck = 0
           for list in Prototype:
               if list == []:
                   break
               NumCheck=0
               for num in list:
                   for value in lengths:
                       if value+50 > num > value -50:
                           NumCheck += 1
                           break
               if NumCheck == len(list):
                   ListCheck += 1
                   continue
               else:
                   break
           if ListCheck == len(Prototype):
               FinalCheck += 1
               break
        if ListCheck == 1:
            result = polyndrome
            break
    return(1)

TestString = '>chrTGCGAATAAAAAACGATCTCGATAAAAAACTCGAAAATCTCGATCTCGATCAAAACAT>chr123ATGTCGATCTCGATCTCGATCTCGATCAAAAAATCGATCTCGATCTCGATCColATTAATo123GCATCGATCTCGAAAAAACTCGATCTCGATCTCGATCT>chr123ATATGTCGATCTCGATCTAAAAAAATGCTA'
PlaceList = []
List_of_substrings = GenomeSplit(TestString)
for substrings in List_of_substrings:
    poly = FindPolyndromes(substrings)
    PlaceList.append(poly)
print(CalculatePolyndrome([10,20,30],PlaceList))
# print(CutPolyndrome(["AAAAAA","ATTAAT","ATGCTA"],PlaceList))

# for i in combinations (['ATGC','ATTT','GCAT'],2):
#     print(i,type(i))
