///Taking three random index values determine a starting pivot.
///Once the starting pivot is setup the initial partition is done
///with the pivot location returned.
///Using the pivot location begin with the left partition
///and sort values in place. Once the left partition is sorted
///then the right partition is sorted. Repeat until left is
///greater than right.

use uniq_vec;

fn median_three<T: Ord>(vals: &mut [T]) {
    //Instead of a median from left, right and middle
    //this implementation picks three random indices and
    //compares the values to find a median for use as the
    //initial pivot value.
    let rand_idx = uniq_vec::new_vec(3, 1, vals.len());

    let median = 
        if vals[rand_idx[0]] > vals[rand_idx[1]] &&
        vals[rand_idx[0]] < vals[rand_idx[2]] {
            rand_idx[0]
        } else if vals[rand_idx[1]] > vals[rand_idx[0]] &&
        vals[rand_idx[1]] < vals[rand_idx[2]] {
            rand_idx[1]
        } else {
            rand_idx[2]
        };

    vals.swap(0, median);
}


fn partition<T: Ord>(array: &mut [T], left: usize, right: usize) -> usize{
    //Move values to the left relative to the pivot value sorting the collection.
    let mut pivot = left;

    for i in left+1..right+1 {
        if array[i] <= array[left] {
            pivot += 1;
            array.swap(i, pivot);
        }
    }
    array.swap(pivot, left);

    //If the vec starts with the lowest number in position 0 then the
    //the first left pass _quicksort call after partition will fail due
    //to an overflow caused by 0 - 1.

    let pivot = match pivot {
        0 => 1,
        _ => pivot
    };
    pivot
}

fn _quicksort<T: Ord>(array: &mut [T], left: usize, right: usize) {
    //Check if left is greater than right at which point the
    //collection has been sorted in place.
    if left >= right {
        return
    }

    let pivot_position = partition(array, left, right);
    _quicksort(array, left, pivot_position -1);
    _quicksort(array, pivot_position + 1, right)
}

pub fn quicksort<T: Ord>(unsorted_vec: &mut [T]) {
    //check vec length and return if not long enough to sort.
    //consider how to change up to use references and no 

    if unsorted_vec.len () <= 1 {
        return
    } else {
        let right = unsorted_vec.len() - 1;
        median_three(unsorted_vec);
        _quicksort(unsorted_vec, 0, right);
    }
}

