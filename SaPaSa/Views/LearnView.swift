import SwiftUI

struct LearnChapter: Identifiable, Hashable {
    let id: String
    let title: String
    let subtitle: String
    let sourcePages: String
    let topics: [String]
    let summary: String
    let practicePrompt: String
}

enum LearnLibrary {
    static let chapters: [LearnChapter] = [
        LearnChapter(
            id: "orientation",
            title: "Orientation",
            subtitle: "What the book covers and how to use it",
            sourcePages: "Opening pages",
            topics: ["Beginner path", "Abhyasa gana", "Practice order"],
            summary: "Ganamrutha Bodhini is arranged as a graded beginner path. It moves from swara exercises into alankaras, theory, geethas, swarajathis, notation, and practice patterns.",
            practicePrompt: "Use this section as a roadmap. Practice slowly, keep tala steady, and only increase speed after the pattern feels even."
        ),
        LearnChapter(
            id: "melakartha-ragas",
            title: "Melakartha Ragas",
            subtitle: "The 72 parent raga framework",
            sourcePages: "Page 8",
            topics: ["Suddha madhyamam", "Prathi madhyamam", "Parent ragas"],
            summary: "The book introduces the melakartha system as the parent raga framework. The first half uses suddha madhyamam and the second half uses prathi madhyamam.",
            practicePrompt: "Start by recognizing familiar melakarthas such as Mayamalavagowla, Kharaharapriya, Harikamboji, Sankarabharanam, Kalyani, and Shanmukhapriya."
        ),
        LearnChapter(
            id: "swaravali-varisaigal",
            title: "Swaravali Varisaigal",
            subtitle: "The first sarali patterns",
            sourcePages: "Lesson 1",
            topics: ["Mayamalavagowla", "Adi tala", "Three speeds"],
            summary: "Swaravali or sarali exercises train the basic ascending and descending movement of swaras. The book places them in Mayamalavagowla and shows how to render them across kalas.",
            practicePrompt: "Sing each line in first speed with clean swaras. Then repeat in second and third speed without changing tala alignment."
        ),
        LearnChapter(
            id: "jantai-varisaigal",
            title: "Jantai Varisaigal",
            subtitle: "Doubled swara strength and clarity",
            sourcePages: "Lesson 2",
            topics: ["Paired swaras", "Voice firmness", "Three speeds"],
            summary: "Jantai patterns repeat swaras in pairs. They build voice control, steadiness, and clarity before moving to wider phrase patterns.",
            practicePrompt: "Keep each repeated swara equal in weight. Avoid pushing the second note harder than the first."
        ),
        LearnChapter(
            id: "dhattu-upper-sthayi",
            title: "Dhattu and Upper Sthayi",
            subtitle: "Jumps, range, and higher-octave practice",
            sourcePages: "Lessons 3-4",
            topics: ["Dhattu movement", "Upper sthayi", "Pitch control"],
            summary: "Dhattu exercises introduce non-linear movement through the swaras. Upper sthayi exercises expand range and help students approach higher notes with control.",
            practicePrompt: "Practice slowly first. For upper sthayi, keep the throat relaxed and let the pitch rise without strain."
        ),
        LearnChapter(
            id: "thalas",
            title: "Thalas",
            subtitle: "Angas, jathis, and akshara counting",
            sourcePages: "Lesson 5",
            topics: ["Anudhrutham", "Dhrutham", "Laghu", "Saptha thalas", "Jathis"],
            summary: "The thala section explains the building blocks of rhythm: beats, waves, finger counts, laghu lengths, and the seven common thala families.",
            practicePrompt: "Before singing an exercise, speak the thala structure aloud and count the aksharas with your hand."
        ),
        LearnChapter(
            id: "saptha-thala-alankaras",
            title: "Saptha Thala Alankaras",
            subtitle: "Applying swaras across tala structures",
            sourcePages: "Lesson 6",
            topics: ["Dhruva", "Matya", "Rupaka", "Jhampa", "Triputa", "Ata", "Eka"],
            summary: "Alankaras combine swara movement with different thala structures. They are a bridge between plain exercises and composed music.",
            practicePrompt: "Clap the thala first without singing. Then add swaras and keep the ending of each cycle precise."
        ),
        LearnChapter(
            id: "swaras-raga-symbols",
            title: "Swaras, Raga, and Symbols",
            subtitle: "Notation basics for reading lessons",
            sourcePages: "Lesson 7",
            topics: ["Seven swaras", "Prakrithi and vikrithi", "Arohanam", "Avarohanam", "Sthayi marks"],
            summary: "This theory section explains the seven swaras, altered swara varieties, raga ascent and descent, octave markings, and notation symbols used in Carnatic lessons.",
            practicePrompt: "When reading notation, first identify the raga scale and octave marks. Then sing only the swaras before adding sahityam."
        ),
        LearnChapter(
            id: "geethas",
            title: "Geethas",
            subtitle: "First composed songs for beginners",
            sourcePages: "Lesson 8",
            topics: ["Malahari", "Suddha Saveri", "Mohanam", "Kalyani", "Saveri", "Kambhoji", "Arabhi"],
            summary: "The geetha section introduces simple compositions in multiple ragas and thalas. These pieces help students connect notation, tala, raga identity, and sahityam.",
            practicePrompt: "Learn one geetham at a time. First sing swaras, then lyrics, then alternate between both until the tune is stable."
        ),
        LearnChapter(
            id: "lakshana-geetham",
            title: "Lakshana Geetham",
            subtitle: "A composition that teaches raga features",
            sourcePages: "After Geethas",
            topics: ["Hari Kedaragowla", "Raga lakshanam", "Composition as theory"],
            summary: "A lakshana geetham combines music and theory. It teaches the shape and features of a raga through a singable composition.",
            practicePrompt: "After learning the tune, compare the phrases with the raga's arohanam and avarohanam."
        ),
        LearnChapter(
            id: "swarajathis",
            title: "Swarajathis",
            subtitle: "Longer forms with pallavi and charanams",
            sourcePages: "Lesson 9",
            topics: ["Bilahari", "Kamas", "Ananda Bhairavi", "Pallavi", "Charanam"],
            summary: "Swarajathis are more elaborate than geethas. They introduce longer structure, repeated sections, and richer melodic movement.",
            practicePrompt: "Break each swarajathi into pallavi and one charanam at a time. Keep the tala cycle visible while memorizing."
        ),
        LearnChapter(
            id: "notes-and-bruga",
            title: "Notes and Bruga Practice",
            subtitle: "Notation studies and speed-building patterns",
            sourcePages: "Lessons 10-11",
            topics: ["Sankarabharanam", "Notation reading", "Bruga patterns", "Akara practice"],
            summary: "The later lessons include notation studies and bruga sadaka patterns. These help with fluency, speed, and clean phrase movement.",
            practicePrompt: "Do not begin fast. Build bruga patterns from slow, even akara practice before adding speed."
        ),
        LearnChapter(
            id: "meanings-and-extra-alankaras",
            title: "Meanings and Extra Alankaras",
            subtitle: "Understanding songs and extending rhythm practice",
            sourcePages: "Closing pages",
            topics: ["Geetha meanings", "Additional alankaras", "Jathi variations"],
            summary: "The closing material explains meanings for the geethas and gives additional alankara patterns across thala and jathi variations.",
            practicePrompt: "Read the meaning before singing lyrics. Understanding the text helps phrasing feel less mechanical."
        )
    ]
}

struct LearnView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                AppTheme.background.ignoresSafeArea()

                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        LearnIntroCard()

                        ForEach(LearnLibrary.chapters) { chapter in
                            NavigationLink {
                                LearnChapterDetailView(chapter: chapter)
                            } label: {
                                LearnChapterRow(chapter: chapter)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(18)
                }
            }
            .navigationTitle("Learn")
        }
    }
}

private struct LearnIntroCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Label("Ganamrutha Bodhini", systemImage: "book.closed.fill")
                .font(.headline)
                .foregroundStyle(AppTheme.primary)

            Text("A chapter-style guide for beginner Carnatic practice, summarized from the scanned book structure without reproducing the copyrighted text.")
                .font(.subheadline)
                .foregroundStyle(AppTheme.mutedInk)
                .fixedSize(horizontal: false, vertical: true)
        }
        .sapasaCard()
    }
}

private struct LearnChapterRow: View {
    let chapter: LearnChapter

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            VStack(alignment: .leading, spacing: 8) {
                Text(chapter.title)
                    .font(.headline)
                    .foregroundStyle(AppTheme.ink)

                Text(chapter.subtitle)
                    .font(.subheadline)
                    .foregroundStyle(AppTheme.mutedInk)
                    .fixedSize(horizontal: false, vertical: true)

                Text(chapter.sourcePages)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(AppTheme.primary)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.caption.weight(.bold))
                .foregroundStyle(AppTheme.mutedInk)
                .padding(.top, 4)
        }
        .sapasaCard()
    }
}

private struct LearnChapterDetailView: View {
    let chapter: LearnChapter

    var body: some View {
        ZStack {
            AppTheme.background.ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text(chapter.title)
                            .font(.system(size: 30, weight: .bold, design: .serif))
                            .foregroundStyle(AppTheme.ink)

                        Text(chapter.subtitle)
                            .font(.subheadline)
                            .foregroundStyle(AppTheme.mutedInk)

                        Text(chapter.sourcePages)
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(AppTheme.primary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .sapasaCard()

                    VStack(alignment: .leading, spacing: 10) {
                        Label("Summary", systemImage: "text.book.closed.fill")
                            .font(.headline)
                            .foregroundStyle(AppTheme.primary)
                        Text(chapter.summary)
                            .font(.body)
                            .foregroundStyle(AppTheme.ink)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .sapasaCard()

                    VStack(alignment: .leading, spacing: 10) {
                        Label("Topics", systemImage: "list.bullet.rectangle.fill")
                            .font(.headline)
                            .foregroundStyle(AppTheme.primary)
                        TopicGrid(chapter: chapter)
                    }
                    .sapasaCard()

                    VStack(alignment: .leading, spacing: 10) {
                        Label("Practice", systemImage: "metronome.fill")
                            .font(.headline)
                            .foregroundStyle(AppTheme.primary)
                        Text(chapter.practicePrompt)
                            .font(.body)
                            .foregroundStyle(AppTheme.ink)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .sapasaCard()
                }
                .padding(18)
            }
        }
        .navigationTitle("Learn")
        .navigationBarTitleDisplayMode(.inline)
    }
}

private struct TopicGrid: View {
    let chapter: LearnChapter

    var body: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 120), spacing: 8)], alignment: .leading, spacing: 8) {
            ForEach(chapter.topics, id: \.self) { topic in
                NavigationLink {
                    LearnTopicDetailView(chapter: chapter, topic: topic)
                } label: {
                    HStack(spacing: 6) {
                        Text(topic)
                            .lineLimit(2)
                        Spacer(minLength: 4)
                        Image(systemName: "chevron.right")
                            .font(.caption2.weight(.bold))
                    }
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(AppTheme.primary)
                    .frame(maxWidth: .infinity, minHeight: 38, alignment: .leading)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 8)
                    .background(AppTheme.primarySoft)
                    .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                }
                .buttonStyle(.plain)
            }
        }
    }
}

private struct LearnTopicDetailView: View {
    let chapter: LearnChapter
    let topic: String

    var body: some View {
        ZStack {
            AppTheme.background.ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text(topic)
                            .font(.system(size: 30, weight: .bold, design: .serif))
                            .foregroundStyle(AppTheme.ink)
                            .fixedSize(horizontal: false, vertical: true)

                        Text(chapter.title)
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(AppTheme.primary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .sapasaCard()

                    TopicInfoCard(
                        title: "Meaning",
                        systemImage: "book.fill",
                        bodyText: LearnTopicContent.meaning(for: topic, chapter: chapter)
                    )

                    TopicInfoCard(
                        title: "How to Practice",
                        systemImage: "music.mic.circle.fill",
                        bodyText: LearnTopicContent.practice(for: topic, chapter: chapter)
                    )

                    TopicInfoCard(
                        title: "Connection",
                        systemImage: "link.circle.fill",
                        bodyText: "This topic belongs to \(chapter.title). \(chapter.summary)"
                    )
                }
                .padding(18)
            }
        }
        .navigationTitle(topic)
        .navigationBarTitleDisplayMode(.inline)
    }
}

private struct TopicInfoCard: View {
    let title: String
    let systemImage: String
    let bodyText: String

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Label(title, systemImage: systemImage)
                .font(.headline)
                .foregroundStyle(AppTheme.primary)

            Text(bodyText)
                .font(.body)
                .foregroundStyle(AppTheme.ink)
                .fixedSize(horizontal: false, vertical: true)
        }
        .sapasaCard()
    }
}

enum LearnTopicContent {
    static func meaning(for topic: String, chapter: LearnChapter) -> String {
        switch topic {
        case "Beginner path":
            return "A gradual sequence for learning Carnatic music: first swara steadiness, then tala alignment, then simple compositions, then longer melodic forms."
        case "Abhyasa gana":
            return "Practice music used to train fundamentals before concert compositions. It includes varisais, alankaras, geethas, swarajathis, and related exercises."
        case "Practice order":
            return "The order matters because each lesson prepares the next one. Swara clarity comes before speed; tala control comes before longer compositions."
        case "Suddha madhyamam":
            return "The first madhyamam variety, used by the first 36 melakartha ragas in the standard 72-raga system."
        case "Prathi madhyamam":
            return "The second madhyamam variety, used by melakarthas 37 through 72. This shift is one of the main divisions in the parent-raga system."
        case "Parent ragas":
            return "Melakartha ragas are parent scales. Many janya ragas are derived from them by omitting, varying, or emphasizing certain swaras and phrases."
        case "Mayamalavagowla":
            return "A foundational melakartha raga often used for early lessons because its swara positions are clear and symmetrical for beginners."
        case "Adi tala":
            return "An eight-akshara tala commonly counted as 4 + 2 + 2. Many beginner exercises and compositions use it."
        case "Three speeds":
            return "The same pattern is rendered with one, two, and then four swaras per beat or unit. This builds control without changing the tala."
        case "Paired swaras":
            return "Repeated swaras such as SS, RR, GG, and so on. They train firmness, clarity, and equal weight between repeated notes."
        case "Voice firmness":
            return "The ability to sing each note steadily without wavering, especially when a swara repeats or appears in faster patterns."
        case "Dhattu movement":
            return "A pattern that jumps across swaras rather than moving only step by step. It improves agility and mental mapping of the raga scale."
        case "Upper sthayi":
            return "The higher octave range. These exercises help students approach higher notes while keeping tone and pitch controlled."
        case "Pitch control":
            return "The skill of landing accurately on each swara, especially when moving between octaves or singing wider jumps."
        case "Anudhrutham":
            return "A tala anga represented by one beat. It has a duration of one akshara."
        case "Dhrutham":
            return "A tala anga with one beat and one wave of the hand, usually counted as two aksharas."
        case "Laghu":
            return "A tala anga made of one beat followed by finger counts. Its length changes depending on the jathi."
        case "Saptha thalas":
            return "The seven thala families: Dhruva, Matya, Rupaka, Jhampa, Triputa, Ata, and Eka."
        case "Jathis":
            return "Jathis define the length of the laghu: thisra, chathurasra, khanda, misra, and sankeerna."
        case "Dhruva", "Matya", "Rupaka", "Jhampa", "Triputa", "Ata", "Eka":
            return "One of the seven thala families. Its structure is defined by a particular arrangement of laghu, dhrutham, and sometimes anudhrutham."
        case "Seven swaras":
            return "The basic swaras are Sa, Ri, Ga, Ma, Pa, Da, and Ni. Sa and Pa are fixed reference points, while the others have varieties."
        case "Prakrithi and vikrithi":
            return "Prakrithi swaras are fixed swaras such as Sa and Pa. Vikrithi swaras are variable swaras such as Ri, Ga, Ma, Da, and Ni."
        case "Arohanam":
            return "The ascending order of swaras in a raga. It shows how the raga moves upward."
        case "Avarohanam":
            return "The descending order of swaras in a raga. It shows how the raga moves downward."
        case "Sthayi marks":
            return "Notation marks used to show octave placement, such as lower, middle, and upper sthayi."
        case "Malahari", "Suddha Saveri", "Mohanam", "Kalyani", "Saveri", "Kambhoji", "Arabhi", "Bilahari", "Kamas", "Ananda Bhairavi", "Sankarabharanam", "Hari Kedaragowla":
            return "A raga used in this learning section. Notice its arohanam, avarohanam, and recurring phrases before memorizing the composition."
        case "Raga lakshanam":
            return "The identifying grammar of a raga: its swaras, important phrases, characteristic movements, and emotional color."
        case "Composition as theory":
            return "Some compositions teach theory through the music itself. A lakshana geetham is meant to reveal raga features while being sung."
        case "Pallavi":
            return "The opening section of a composition. It usually establishes the main musical idea."
        case "Charanam":
            return "A later section of a composition that develops the melody and text beyond the opening idea."
        case "Notation reading":
            return "The skill of translating written swaras, pauses, duration marks, and tala divisions into sung music."
        case "Bruga patterns":
            return "Fast phrase patterns used to build agility. They should be learned slowly before adding speed."
        case "Akara practice":
            return "Singing on the vowel sound 'aa' instead of lyrics or swara names. It helps tone, breath, and phrase smoothness."
        case "Geetha meanings":
            return "The meaning of a song's sahityam. Understanding meaning supports better phrasing and expression."
        case "Additional alankaras":
            return "Extra structured swara patterns that extend tala and jathi practice beyond the basic set."
        case "Jathi variations":
            return "Different laghu lengths that change the total akshara count of a tala while preserving the tala family."
        default:
            return "A focused concept from \(chapter.title). Use it as a small study unit before returning to the full chapter."
        }
    }

    static func practice(for topic: String, chapter: LearnChapter) -> String {
        switch topic {
        case "Three speeds":
            return "Set a slow tala. Sing the same phrase in first speed, then second, then third. If the tala slips, return to first speed."
        case "Adi tala":
            return "Count 4 + 2 + 2 with your hand before singing. Keep the same hand cycle while adding swaras."
        case "Paired swaras", "Voice firmness":
            return "Sing each pair evenly: do not accent the second note. Keep the tone steady and the pitch centered."
        case "Dhattu movement", "Upper sthayi", "Pitch control":
            return "Practice in short phrases. Pause after each phrase and check whether the landing note is accurate."
        case "Anudhrutham", "Dhrutham", "Laghu", "Saptha thalas", "Jathis":
            return "Clap and count without singing first. Once the cycle feels automatic, add simple Sa-Ri-Ga patterns."
        case "Arohanam", "Avarohanam", "Raga lakshanam":
            return "Sing the ascent and descent slowly. Then find the same movements inside a song or exercise."
        case "Bruga patterns", "Akara practice":
            return "Begin on akara at a slow tempo. Increase speed only when every note remains clear."
        case "Pallavi", "Charanam":
            return "Memorize one section at a time. Sing it with tala, then connect it back to the previous section."
        case "Geetha meanings":
            return "Read the meaning first, then sing the line. Let the musical phrase follow the sense of the words."
        default:
            return chapter.practicePrompt
        }
    }
}
