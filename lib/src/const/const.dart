// app name
import 'package:intl/intl.dart';

final formatter = NumberFormat('#,##0');

const String appNameEn = 'Abacus Simple Anzan';
const String appNameKr = '주산심플암산';
const String appNameJa = '珠算簡単暗算';

// mode, option button (top)
const String modeKr = '색상 모드 바꾸기';
const String modeEn = 'Change theme';
const String modeJa = 'カラー テーマ 交換';

const String soundKr = '소리 실행/끄기';
const String soundEn = 'Sound On/Off';
const String soundJa = '音を立てる/消す';

const String fastSettingKr = '빠른 설정';
const String fastSettingEn = 'Fast Setting';
const String fastSettingJa = '簡便設定';

// routers
const String mainPageAddress = '/';
const String settingsPageAddress = '/settings';
const String multiplyPageAddress = '/multiply';
const String settingsmultiplyPageAddress = '/settings/multiply';
const String errorPageAddress = '/error';
const String loadingPageAddress = '/loading';

// bottom navigation labels
const String homePlusLabelEn = 'addition';
const String settingPlusLabelEn = '+/-';
const String homeMultiplyLabelEn = 'multiplication';
const String settingMultiplyLabelEn = ' ×/÷';

const String homePlusLabelKr = '덧셈';
const String settingPlusLabelKr = '+/-';
const String homeMultiplyLabelKr = '곱셈';
const String settingMultiplyLabelKr = ' ×/÷';

const String homePlusLabelJa = '足し算';
const String settingPlusLabelJa = '+/-';
const String homeMultiplyLabelJa = '掛け算';
const String settingMultiplyLabelJa = ' ×/÷';

// button strings
const String okKr = '확인';
const String okEn = 'Ok';
const String okJa = '確認';

const String startKr = '시작 !!';
const String startEn = 'Start !!';
const String startJa = 'スタート';

const String hidden = ' ';

const String checkKr = '정답 확인';
const String checkEn = 'Check Answer';
const String checkJa = '正解を見る';

// error page strings
const String error = 'The page you requested does not exist.';

// options(settings && common)
const String settingsKr = '설정';
const String shuffleKr = '섞기';
const String onlyPlusesKr = '덧셈(+)만 하기';
const String speedKr = "문제 속도";
const String digitKr = "자리 수";
const String numOfProblemsKr = "문제 수";

const String settingsEn = 'Settings';
const String shuffleEn = 'Shuffle';
const String onlyPlusesEn = 'Only pluses';
const String speedEn = "Speed";
const String digitEn = "Digit";
const String numOfProblemsEn = "Questions";

const String settingsJa = '設定';
const String shuffleJa = 'シャッフル';
const String onlyPlusesJa = '足し算だけ';
const String speedJa = "速度";
const String digitJa = "桁数";
const String numOfProblemsJa = "問題数";

const String notifyKr = '시작 전 알림';
const String notifyEn = 'notify at start';
const String notifyJa = '事前通知';

// option(multiply)
const String settingsMultiplyKr = '설정 (곱셈)';
const String isMultiplyKr = '나눗셈 하기';
const String speedMultiplyKr = "문제 속도";
const String bigDigitMultiplyKr = "큰 자리 수";
const String smallDigitMultiplyKr = "작은 자리 수";
const String numOfProblemsMultiplyKr = "문제 수";

const String settingsMultiplyEn = 'Settings (multiplication)';
const String isMultiplyEn = 'Change to division';
const String speedMultiplyEn = "Speed";
const String bigDigitMultiplyEn = "Big Digit";
const String smallDigitMultiplyEn = "Small Digit";
const String numOfProblemsMultiplyEn = "Questions";

const String settingsMultiplyJa = '設定(掛け算)';
const String isMultiplyJa = '割り算';
const String speedMultiplyJa = "速さ";
const String bigDigitMultiplyJa = "大桁の数";
const String smallDigitMultiplyJa = "小桁の数";
const String numOfProblemsMultiplyJa = "問題数";

// custom option related

const String setSpeedTitleKr = '속도를 설정합니다. (1000 = 1초)';
const String rangeWordKr = '100~5000 사이의 값을 입력하세요.';
const String pleaseInsertValueKr = '값을 입력하세요.';
const String pleaseTooBigValueKr = '값이 너무 큽니다.';
const String pleaseTooSmallValueKr = '값이 너무 작습니다.';

const String setSpeedTitleEn = 'Set custom speed. (1000 = 1sec)';
const String rangeWordEn = 'put value between 100~5000.';
const String pleaseInsertValueEn = 'the value is empty.';
const String pleaseTooBigValueEn = 'too big value.';
const String pleaseTooSmallValueEn = 'too small value.';

const String setSpeedTitleJa = '速度を設定します。(1000 = 1秒)';
const String rangeWordJa = '100~5000の値を入れてください。';
const String pleaseInsertValueJa = '値段が空きました。';
const String pleaseTooBigValueJa = '値段が大きすぎます。';
const String pleaseTooSmallValueJa = '値段が小さすぎます。';

const String shuffleDescKr = '다른 자릿수와 섞어 계산합니다.';
const String shuffleDescEn = 'shuffle numbers with different digits';
const String shuffleDescJa = '他の桁と混ぜて計算します。';

const String rangeMultiplyWordKr = '100~30000 사이의 값을 입력하세요.';
const String rangeMultiplyWordEn = 'put value between 100~30000.';
const String rangeMultiplyWordJa = '100~30000の値を入れてください。';

const String insertBiggerKr = '작은 자리 수가 큰 자리 수보다 작아야 합니다.';
const String insertBiggerEn = 'Small digit should be smaller.';
const String insertBiggerJa = '小さい席の数がもっと大きいです。';

// prob list
const String noProbExecutedKr = '실행된 문제가 없습니다.';
const String noProbExecutedEn = 'Run calculation first.';
const String noProbExecutedJa = '問題を先に実行してください。';

const String checkProbKr = '문제 & 정답 확인';
const String checkProbEn = 'Check Questions & Answers';
const String checkProbJa = '問題リストの確認';

const String checkProbQKr = '문제 리스트 확인';
const String checkProbQEn = 'Check Questions';
const String checkProbQJa = '問題リストの確認';

const String problemKr = '문제';
const String problemEn = 'question';
const String problemJa = '問題';

const String answerKr = '정답';
const String answerEn = 'answer';
const String answerJa = '正答';

// other
const String empty = '';
const String defaultFontFamily = 'Roboto';

const String warningKr = '경고';
const String warningEn = 'Warning';
const String warningJa = '警告';
