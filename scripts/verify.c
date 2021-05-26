#include <stdio.h>
#include <math.h>


double ConvertNumberToFloat(unsigned long number, int isDoublePrecision)
{
    int mantissaShift = isDoublePrecision ? 52 : 23;
    unsigned long exponentMask = isDoublePrecision ? 0x7FF0000000000000 : 0x7f800000;
    int bias = isDoublePrecision ? 1023 : 127;
    int signShift = isDoublePrecision ? 63 : 31;

    int sign = (number >> signShift) & 0x01;
    int exponent = ((number & exponentMask) >> mantissaShift) - bias;

    int power = -1;
    double total = 0.0;
    for ( int i = 0; i < mantissaShift; i++ )
    {
        int calc = (number >> (mantissaShift-i-1)) & 0x01;
        total += calc * pow(2.0, power);
        power--;
    }
    double value = (sign ? -1 : 1) * pow(2.0, exponent) * (total + 1.0);

    return value;
}

int main()
{
    // // Single Precision 
    // unsigned int singleValue = 0x40490FDB; // 3.141592...
    // float singlePrecision = (float)ConvertNumberToFloat(singleValue, 0);
    // printf("IEEE754 Single (from 32bit 0x%08X): %.7f\n",singleValue,singlePrecision);

    // // Double Precision
    // unsigned long doubleValue = 0x3FC7997ED8A0A6C4; // 3.141592653589793... 
    // double doublePrecision = ConvertNumberToFloat(doubleValue, 1);
    // // printf("IEEE754 Double (from 64bit 0x%016lX): %.16f\n",doubleValue,doublePrecision);
    
    unsigned long A = 0x3FC7997ED8A0A6C4;
    double A_fp = ConvertNumberToFloat(A, 1);
    unsigned long B = 0x3FD69C1D9F1BDE80;
    double B_fp = ConvertNumberToFloat(B, 1);

    unsigned long C = 0x3FE7EE6B344E123F;
    double C_fp = ConvertNumberToFloat(C, 1);

    // unsigned long C_compare = 0x3FEA04005F462880;
    // double C_compare_fp = ConvertNumberToFloat(C_compare, 1);

    double AB_mul = A_fp*B_fp;
    double res = AB_mul + C_fp;
    double res_fma = fma(A_fp, B_fp, C_fp);

    printf( "%016lX\n%016lx" , *(unsigned long int*)&res, *(unsigned long int*)&res_fma );
}

