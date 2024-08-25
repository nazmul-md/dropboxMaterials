const quiz1 = {
    questions: [
        {
            question: "What is 2 + 2?",
            choices: ["3", "4", "5"],
            correct: 1,
        },
        {
            question: "What is the capital of France?",
            choices: ["London", "Berlin", "Paris"],
            correct: 2,
        },
    ],
};

const quiz2 = {
    questions: [
        {
            question: "Which planet is known as the Red Planet?",
            choices: ["Earth", "Mars", "Jupiter"],
            correct: 1,
        },
        {
            question: "What is 10 * 5?",
            choices: ["20", "50", "100"],
            correct: 1,
        },
    ],
};

let currentQuiz = null;
let currentQuestionIndex = 0;
let score = 0;
let timeLeft = 10;
let timerInterval;

function startQuiz(quiz) {
    currentQuiz = quiz;
    currentQuestionIndex = 0;
    score = 0;
    timeLeft = 10;
    showQuestion();
    showQuiz();
    startTimer();
}

function showQuiz() {
    document.getElementById("quiz-selection").style.display = "none";
    document.getElementById("quiz").style.display = "block";
}

function showQuestion() {
    const questionElement = document.getElementById("question");
    const choicesElement = document.getElementById("choices");
    const progressElement = document.getElementById("progress");

    const currentQuestion = currentQuiz.questions[currentQuestionIndex];
    questionElement.textContent = currentQuestion.question;

    choicesElement.innerHTML = "";
    currentQuestion.choices.forEach((choice, index) => {
        const choiceButton = document.createElement("button");
        choiceButton.textContent = choice;
        choiceButton.onclick = () => checkAnswer(index);
        choicesElement.appendChild(choiceButton);
    });

    progressElement.textContent = `Question ${currentQuestionIndex + 1} of ${currentQuiz.questions.length}`;
}

function startTimer() {
    timerInterval = setInterval(() => {
        if (timeLeft > 0) {
            timeLeft--;
            document.getElementById("time-left").textContent = timeLeft;
        } else {
            clearInterval(timerInterval);
            checkAnswer(-1); // Time's up, check as incorrect
        }
    }, 1000);
}

function checkAnswer(selectedIndex) {
    clearInterval(timerInterval);

    if (selectedIndex === currentQuiz.questions[currentQuestionIndex].correct) {
        score++;
    }

    currentQuestionIndex++;

    if (currentQuestionIndex < currentQuiz.questions.length) {
        showQuestion();
        startTimer();
    } else {
        endQuiz();
    }
}

function endQuiz() {
    const quizElement = document.getElementById("quiz");
    quizElement.innerHTML = `<h2>Your Score: ${score} / ${currentQuiz.questions.length}</h2>`;
}
``
