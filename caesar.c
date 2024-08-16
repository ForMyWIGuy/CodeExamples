#include <stdlib.h>
#include <stdio.h>
#include <ctype.h>
#include <cs50.h>
#include <string.h>

bool only_digits(string key);
string encode_text(string message, int num_key);
//from lecture, using main to allow user input
//at the command line
//argc = total number of arguments typed
int main(int argc, string argv[])
{
    if (argc != 2)
    {
        printf("Usage: ./caesar key\n");
        return 1;
    }
    string key = argv[1];
    //printf("key equals: %s\n", key);

    bool result = only_digits(key);
    printf("only_digits output: %i\n", result);
    if ((result) == false)
    {
        printf("Usage: ./caesar key\n");
        return 1;
    }
    int num_key = atoi(key);
    //printf("%i is the key\n", num_key);
//convert argv[1] (key) from string to int
    string message = get_string("plaintext:  ");
    encode_text(message, num_key);
    printf("ciphertext: %s\n", message);

}

bool only_digits(string key)
{
    int n = strlen(key);
    // prints length of key "string" type printf("string length of key aka n = %i\n", n);

    for (int i = 0; i < n; i++)
    {
        //prints the iterations of only_digitst for loop printf("i = %i\n", i);
        //printf("Key [%i] = %c\n", i, key[i]);
        if (isblank(key[i]))
        {
            //printf("Blank key = %c\n", key[i]);
            printf("Usage: ./caesar key\n");
            return false;
        }
        else if (isalpha(key[i]))
        {
            //printf("Key is letters\n");
            printf("Usage: ./caesar key\n");
            return false;
        }
        else if (isdigit(key[i]))
        {
            //printf("Key is digits\n");
        }
        else
        {
            //printf("key is something else\n");
            printf("Usage: ./caesar key\n");
            return false;
        }
    }
    return true;
}

string encode_text(string message, int num_key)
{
    int n = strlen(message);
    string cyphertext = message;
    num_key = num_key % 26;

    for (int i = 0; i < n; i++)
    {
        //printf("i equals %i and the character's ascii value is %i\n", i, message[i]);
        //printf("i equals %i and message character is %c.\n", i, message[i]);

        //uppercase
        if isupper(message[i])
        {
            int c = ((int) message[i] + num_key);
            if (c > 'Z')
            {
                c = c - 26;
                //printf("cyphertext char is %c and is its %i ascii value \n", c, c);
            }
            else if (c < 'A')
            {
                c = c + 26;
                //printf("After > Z or < A block in UPPER case: %c and ascii value is %i.\n", c, c);
            }
            cyphertext[i] = c;
        }
        //lowercase
        else if islower(message[i])
        {
            int c = ((int) message[i] + num_key);
            if (c > 'z')
            {
                c = c - 26;
                //printf("c char is %c and is its %i ascii \n", c, c);
            }
            else if (c < 'a')
            {
                c = c + 26;
                //printf("After > Z or < A block in UPPER case: %c  ascii is %i.\n", c, c);
            }
            cyphertext[i] = c;
        }
        else
        {
            //printf("cyper unchanged digit here _%c_\n", message[i]);
        }
    }
    //printf("Cyphertext: %s\n", cyphertext);
    return 0;
}

//if_special_character - do not interpret those - just copy forward
//ifuppercase + key = cyphertext
//iflowercase + key = cyphertext
//remember A = 65 and prob need calculation with that in there
//remember a = 97 same as above
//use atoi and ASCII values conversions
//remember %26 to wrap the cypher back around the alphabet.



