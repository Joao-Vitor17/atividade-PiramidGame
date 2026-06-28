class AppConstants {
  static const String appName = 'PirâmidGame IFPR-Pgua';
  static const String subtitle = 'Ranking de Popularidade dos Alunos';
  static const String campus = 'IFPR – Campus Paranaguá';

  // Shared Preferences Keys
  static const String studentListKey = 'students_list';
  static const String themeKey = 'theme_mode';

  // Courses
  static const List<String> courses = ['INFO', 'MEC', 'MAMB', 'PROD', 'TADS', 'TGA'];

  // Years
  static const int minYear = 1998;
  static const int maxYear = 2026;

  // Rating criteria
  static const List<String> ratingCriteria = [
    'Resenha',
    'Presença VIP',
    'Aura',
    'Modo Parceiro',
    'Carisma Natural',
    'Humor de Milhões',
    'Energia de Grupo',
    'Criatividade Caótica',
    'Modo Atleta',
    'Talento de Palco',
    'Drip Escolar',
    'Coração de Dorama',
    'Queridinho dos Professores',
    'Cérebro Turbo',
    'Caos Controlado',
  ];

  static const List<String> ratingDescriptions = [
    'Mede o quanto o aluno anima a turma, puxa conversa e contribui para deixar o ambiente mais descontraído.',
    'Avalia o quanto o aluno é lembrado, percebido ou reconhecido pelos colegas no dia a dia da turma.',
    'Representa a energia geral do aluno: presença, estilo, jeito de ser e impacto que causa no ambiente.',
    'Mede o quanto o aluno ajuda os colegas, colabora nas atividades e demonstra espírito de parceria.',
    'Avalia a facilidade do aluno para socializar, conversar e criar boas relações com os colegas.',
    'Representa o quanto o aluno contribui com bom humor, brincadeiras saudáveis e momentos divertidos.',
    'Mede a participação do aluno em trabalhos, eventos, jogos, dinâmicas e atividades coletivas da turma.',
    'Avalia a capacidade do aluno de ter ideias diferentes, soluções inesperadas e comentários geniais.',
    'Representa a aptidão esportiva, a disposição física e o espírito competitivo saudável do aluno.',
    'Mede a aptidão artística do aluno, como música, canto, instrumentos, dança, ritmo ou presença em apresentações.',
    'Avalia o estilo pessoal do aluno, considerando roupas, tênis, cabelo, acessórios e presença visual.',
    'Representa o carisma afetivo, a gentileza e aquela vibe de protagonista romântico.',
    'Mede a boa relação do aluno com os professores, considerando respeito, participação, educação e responsabilidade.',
    'Avalia o desempenho nos estudos, a facilidade para aprender, resolver problemas e se destacar academicamente.',
    'Mede o quanto o aluno é bagunceiro, zoeiro ou imprevisível, mas ainda dentro dos limites do respeito e convivência saudável.',
  ];

  static const int maxRating = 5;
  static const int minRating = 1;
  static const int totalCriteria = 15;
  static const int maxPoints = totalCriteria * maxRating; // 75
  static const int minPoints = totalCriteria * minRating; // 15
}
