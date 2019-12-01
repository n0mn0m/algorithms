## Merge sort in ASM

This repo is an implementation of merge sort in MIPS along with a print function for the array elements to assist in debugging.

### C representation

```
void mergeSort(int arr[], int l, int r) {
  if (l < r) {
      // Same as (l+r)/2, but avoids overflow for
      // large l and r
      int m = l + (r - l) / 2;
      // Sort first and second halves
      mergeSort(arr, l, m);
      mergeSort(arr, m + 1, r);
      // Merge the resulting arrays,
      merge(arr, l, m, r);
  }
}

void merge(int arr[], int l, int m, int r) {
    int i = m;
    int j = m + 1;
    while (j <= r) {
        int x = i;
        int y = j;
        while (arr[x] > arr[y] && x >= l) {
            swap(arr, x, y);
            x--;
            y--;
        }
        i = j;
        j++;
    }
}

void swap(int* array, int x , int y) {
  int temp = array[x];
  array[x] = array[y];
  array[y] = temp;
}

```

### MIPS names guide

`.data`  Defines variable section of an assembly routine.

`array:` Defines your array of elements. In this case MIPS words

`.text`  Defines the start of the code section for the program .
