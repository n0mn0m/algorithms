///Function to generate a vector of three random index values
///that exist within the range of the collection being sorted.
///These three random indexes are used to find the initial pivot.

extern crate rand;

use rand::Rng;
use rand::distributions::range::SampleRange;

pub fn new_vec<T: Ord + SampleRange + Copy>(size: usize, min: T, max: T) -> Vec<T> {
    let mut unq_vec = Vec::new();
    while unq_vec.len() < size {
        let val = rand::thread_rng().gen_range(min, max);
        if !unq_vec.contains(&val) {
            unq_vec.push(val);
        }
    };
    unq_vec
}
