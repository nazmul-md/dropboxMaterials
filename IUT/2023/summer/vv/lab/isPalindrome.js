function isPalindrome(number) {
    let original = number;
    let reminder, reversed = 0;
    while(number >= 1) {
        reminder = parseInt(number%10);
        reversed = reversed*10 + reminder;
        number = parseInt(number / 10);
    }
    if(original == reversed) return true;
    return false;
}
console.log(isPalindrome(1213))
module.exports = {
    isPalindrome
}