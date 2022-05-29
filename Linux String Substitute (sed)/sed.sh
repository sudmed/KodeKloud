### Linux String Substitute (sed)
: '
On Nautilus App Server 1, alter the /home/BSD.txt file as per details given below:
a. Delete all lines containing word code and save results in /home/BSD_DELETE.txt file. (Please be aware of case sensitivity)
b. Replace all occurrence of word or to for and save results in /home/BSD_REPLACE.txt file.
Note: Let's say you are asked to replace word to with from. In that case, make sure not to alter any words containing this string; for example upto, contributor etc.
- Make sure to replace all the occurences of 'or' to 'for' in '/home/BSD_REPLACE.txt' on stapp01
'


cd /home
cat BSD.txt
sed -e '/code/d' BSD.txt > /home/BSD_DELETE.txt
#sed -e 's/or/for/g' /home/BSD.txt > /home/BSD_REPLACE.txt
sed -e 's/\<the\>/for/g' BSD.txt > BSD_REPLACE.txt


### Explaining
# https://www.gnu.org/software/sed/manual/sed.html
: '
\<
Matches the beginning of a word.
$ echo "abc %-= def." | sed 's/\</X/g'
Xabc %-= Xdef.

\>
Matches the end of a word.
$ echo "abc %-= def." | sed 's/\>/X/g'
abcX %-= defX.
'



```bash
sed -e '/software/d' /home/BSD.txt > /home/BSD_DELETE.txt
```


```bash
sed -e 's/\<the\>/them/g' /home/BSD.txt > /home/BSD_REPLACE.txt
```
